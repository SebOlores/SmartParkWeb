using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace SmartParkWeb
{
    public partial class VehicleExit : Page
    {
        protected void Page_Load(object s, EventArgs e)
        {
            if (Session["user"] == null) Response.Redirect("Login.aspx");
            if (!IsPostBack) LoadParked("");
        }
        void LoadParked(string search)
        {
            DataTable dt = DbHelper.ExecProc("sp_GetParkedVehicles",
                new SqlParameter("@Search", search ?? ""));
            // Safely convert IsPaid to bool
            foreach (DataRow row in dt.Rows)
            {
                row["IsPaid"] = Convert.ToBoolean(row["IsPaid"]);
            }
            rptParked.DataSource = dt;
            rptParked.DataBind();
        }
        protected void txtSearch_Changed(object s, EventArgs e)
        {
            LoadParked(txtSearch.Text.Trim());
        }
        // ── PAY — records payment, adds to revenue
        protected void btnConfirmPay_Click(object s, EventArgs e)
        {
            if (!string.IsNullOrEmpty(hfPayVehicleId.Value))
            {
                int vid = int.Parse(hfPayVehicleId.Value);
                DbHelper.ExecProc("sp_MarkPaid",
                    new SqlParameter("@VehicleId", vid));
                lblMsg.Text = "✔ Payment recorded successfully!";
                lblMsg.CssClass = "sp-alert-success";
                lblMsg.Visible = true;
                hfPayVehicleId.Value = "";
            }
            LoadParked(txtSearch.Text.Trim());
        }
        // ── EXIT — just removes from parked list, no payment added
        protected void btnConfirmExit_Click(object s, EventArgs e)
        {
            if (!string.IsNullOrEmpty(hfExitVehicleId.Value))
            {
                int vid = int.Parse(hfExitVehicleId.Value);
                DbHelper.ExecProc("sp_VehicleExit",
                    new SqlParameter("@VehicleId", vid));
                lblMsg.Text = "✔ Vehicle has exited successfully.";
                lblMsg.CssClass = "sp-alert-success";
                lblMsg.Visible = true;
                hfExitVehicleId.Value = "";
            }
            LoadParked(txtSearch.Text.Trim());
        }
        protected void rptParked_Command(object s, RepeaterCommandEventArgs e)
        {
            LoadParked(txtSearch.Text.Trim());
        }
    }
}