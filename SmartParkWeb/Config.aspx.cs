using iTextSharp.text;
using iTextSharp.text.pdf;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Printing;
using System.IO;
using System.Web.UI;
using System.Xml.Linq;

namespace SmartParkWeb
{
    public partial class Config : Page
    {
        protected void Page_Load(object s, EventArgs e)
        {
            if (Session["user"] == null) Response.Redirect("Login.aspx");
            if (!IsPostBack) LoadConfig();
        }

        void LoadConfig()
        {
            DataTable dt = DbHelper.ExecProc("sp_GetDashboard");
            if (dt.Rows.Count > 0)
            {
                DataRow r = dt.Rows[0];
                txtSlots.Text = r["TotalSlots"].ToString();
                lblCurrently.Text = r["ParkedNow"].ToString();
                txtCarRate.Text = r["CarRate"].ToString();
                txtMotorRate.Text = r["MotorRate"].ToString();
            }
        }

        protected void btnSlots_Click(object s, EventArgs e)
        {
            DbHelper.ExecProc("sp_UpdateSlots",
                new SqlParameter("@TotalSlots", int.Parse(txtSlots.Text)));
            lblMsg.Text = "✔ Capacity saved successfully!";
            lblMsg.CssClass = "sp-alert-success";
            lblMsg.Visible = true;
        }

        protected void btnFlatRate_Click(object s, EventArgs e)
        {
            DbHelper.ExecProc("sp_UpdateRates",
                new SqlParameter("@CarRate", decimal.Parse(txtCarRate.Text)),
                new SqlParameter("@MotorRate", decimal.Parse(txtMotorRate.Text)));
            lblMsg.Text = "✔ Flat rates saved successfully!";
            lblMsg.CssClass = "sp-alert-success";
            lblMsg.Visible = true;
        }

        protected void btnGenReport_Click(object s, EventArgs e)
        {
            string filter = ddlReportFilter.SelectedValue;
            string filterLabel = ddlReportFilter.SelectedItem.Text;

            // Fetch data
            DataSet ds = new DataSet();
            using (var conn = DbHelper.GetConnection())
            using (var cmd = new SqlCommand("sp_GetTransactionReport", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Filter", filter);
                new SqlDataAdapter(cmd).Fill(ds);
            }

            DataTable summary = ds.Tables[0];
            DataTable daily = ds.Tables[1];
            DataRow sum = summary.Rows.Count > 0 ? summary.Rows[0] : null;

            using (var ms = new MemoryStream())
            {
                var doc = new Document(PageSize.A4, 40, 40, 50, 50);
                PdfWriter.GetInstance(doc, ms);
                doc.Open();

                // Colors & fonts
                var green = new BaseColor(22, 163, 74);
                var lightGreen = new BaseColor(240, 253, 244);
                var darkText = new BaseColor(17, 24, 39);
                var grayText = new BaseColor(107, 114, 128);
                var rowAlt = new BaseColor(249, 250, 251);

                var fTitle = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 22, green);
                var fSub = FontFactory.GetFont(FontFactory.HELVETICA, 11, grayText);
                var fSection = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 13, darkText);
                var fNormal = FontFactory.GetFont(FontFactory.HELVETICA, 11, darkText);
                var fWhite = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 11, BaseColor.WHITE);
                var fBigGreen = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 18, green);
                var fSmGray = FontFactory.GetFont(FontFactory.HELVETICA, 10, grayText);

                // ── Header
                doc.Add(new Paragraph("SmartPark", fTitle) { SpacingAfter = 2 });
                doc.Add(new Paragraph("Transaction Report — " + filterLabel, fSub) { SpacingAfter = 4 });
                doc.Add(new Paragraph("Generated: " + DateTime.Now.ToString("MMMM dd, yyyy hh:mm tt"), fSub) { SpacingAfter = 14 });

                var line = new iTextSharp.text.pdf.draw.LineSeparator(1f, 100f, green, Element.ALIGN_LEFT, -2);
                doc.Add(new Chunk(line));
                doc.Add(new Paragraph(" ") { SpacingAfter = 10 });

                // ── Summary cards
                if (sum != null)
                {
                    doc.Add(new Paragraph("Summary", fSection) { SpacingAfter = 10 });

                    void AddCardRow(string[] labels, string[] values)
                    {
                        var t = new PdfPTable(labels.Length) { WidthPercentage = 100, SpacingAfter = 10 };
                        for (int i = 0; i < labels.Length; i++)
                        {
                            var cell = new PdfPCell { BackgroundColor = lightGreen, Border = iTextSharp.text.Rectangle.NO_BORDER, Padding = 12 };
                            cell.AddElement(new Paragraph(values[i], fBigGreen));
                            cell.AddElement(new Paragraph(labels[i], fSmGray));
                            t.AddCell(cell);
                        }
                        doc.Add(t);
                    }

                    AddCardRow(
                        new[] { "Total Transactions", "Total Revenue", "Avg per Transaction" },
                        new[] {
                            sum["TotalTransactions"].ToString(),
                            "₱" + decimal.Parse(sum["TotalRevenue"].ToString()).ToString("0.00"),
                            "₱" + decimal.Parse(sum["AvgPerTransaction"].ToString()).ToString("0.00")
                        }
                    );
                    AddCardRow(
                        new[] { "Highest Payment", "Cars", "Motors" },
                        new[] {
                            "₱" + decimal.Parse(sum["HighestPayment"].ToString()).ToString("0.00"),
                            sum["CarCount"].ToString(),
                            sum["MotorCount"].ToString()
                        }
                    );
                }

                // ── Daily breakdown table
                doc.Add(new Paragraph("Daily Breakdown", fSection) { SpacingAfter = 10 });

                if (daily.Rows.Count > 0)
                {
                    var t = new PdfPTable(3) { WidthPercentage = 100, SpacingAfter = 10 };
                    t.SetWidths(new float[] { 2f, 1f, 1.5f });

                    foreach (string h in new[] { "Date", "Transactions", "Revenue" })
                        t.AddCell(new PdfPCell(new Phrase(h, fWhite))
                        { BackgroundColor = green, Border = iTextSharp.text.Rectangle.NO_BORDER, Padding = 10 });

                    bool alt = false;
                    foreach (DataRow row in daily.Rows)
                    {
                        var bg = alt ? rowAlt : BaseColor.WHITE;
                        string dateStr = DateTime.Parse(row["PayDate"].ToString()).ToString("MMM dd, yyyy");
                        foreach (string val in new[] {
                            dateStr,
                            row["TxCount"].ToString(),
                            "₱" + decimal.Parse(row["DayRevenue"].ToString()).ToString("0.00")
                        })
                            t.AddCell(new PdfPCell(new Phrase(val, fNormal))
                            {
                                BackgroundColor = bg,
                                Border = iTextSharp.text.Rectangle.NO_BORDER,
                                Padding = 9,
                                BorderWidthBottom = 0.5f,
                                BorderColorBottom = new BaseColor(229, 231, 235)
                            });
                        alt = !alt;
                    }
                    doc.Add(t);
                }
                else
                {
                    doc.Add(new Paragraph("No transactions found for this period.", fSub));
                }

                // ── Footer
                doc.Add(new Paragraph(" "));
                doc.Add(new Chunk(line));
                doc.Add(new Paragraph("SmartPark Management System — Confidential", fSub));

                doc.Close();

                // Download
                byte[] bytes = ms.ToArray();
                string filename = "SmartPark_Report_" + filterLabel.Replace(" ", "_") + "_" + DateTime.Now.ToString("yyyyMMdd") + ".pdf";
                Response.Clear();
                Response.ContentType = "application/pdf";
                Response.AddHeader("content-disposition", "attachment; filename=" + filename);
                Response.BinaryWrite(bytes);
                Response.End();
            }
        }

        protected void btnClear_Click(object s, EventArgs e)
        {
            DbHelper.ExecProc("sp_ClearAllData");
            lblMsg.Text = "✔ All data cleared successfully!";
            lblMsg.CssClass = "sp-alert-success";
            lblMsg.Visible = true;
            LoadConfig();
        }
    }
}