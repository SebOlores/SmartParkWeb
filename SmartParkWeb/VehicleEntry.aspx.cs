using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
namespace SmartParkWeb
{
    public partial class VehicleEntry : Page
    {
        private static DateTime PhTime()
        {
            TimeZoneInfo ph = TimeZoneInfo.FindSystemTimeZoneById("Singapore Standard Time");
            return TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, ph);
        }

        protected void Page_Load(object s, EventArgs e)
        {
            if (Session["user"] == null) Response.Redirect("Login.aspx");
            if (!IsPostBack)
                txtEntry.Text = PhTime().ToString("MM/dd/yyyy hh:mm tt");
        }
        protected void btnCar_Click(object s, EventArgs e)
        {
            hfType.Value = "Car";
            btnCar.CssClass = "sp-type-btn active";
            btnMotor.CssClass = "sp-type-btn";
        }
        protected void btnMotor_Click(object s, EventArgs e)
        {
            hfType.Value = "Motor";
            btnMotor.CssClass = "sp-type-btn active";
            btnCar.CssClass = "sp-type-btn";
        }
        protected void btnRecord_Click(object s, EventArgs e)
        {
            string plate = txtPlate.Text.Trim().ToUpper();
            if (string.IsNullOrEmpty(plate))
            {
                lblErr.Text = "⚠ Plate number is required.";
                lblErr.CssClass = "sp-alert-error";
                lblErr.Visible = true;
                lblMsg.Visible = false;
                return;
            }
            try
            {
                // Check if plate is currently parked
                DataTable check = DbHelper.ExecProc("sp_CheckPlate",
                    new SqlParameter("@PlateNumber", plate));
                bool alreadyParked = check.Rows.Count > 0;
                DbHelper.ExecProc("sp_VehicleEntry",
                    new SqlParameter("@PlateNumber", plate),
                    new SqlParameter("@VehicleType", hfType.Value),
                    new SqlParameter("@Notes", txtNotes.Text));
                if (alreadyParked)
                    lblMsg.Text = "✔ Vehicle " + plate + " recorded! (Note: this plate also has an active session)";
                else
                    lblMsg.Text = "✔ Vehicle " + plate + " recorded successfully!";
                lblMsg.CssClass = "sp-alert-success";
                lblMsg.Visible = true;
                lblErr.Visible = false;
                // Reset form
                txtPlate.Text = "";
                txtNotes.Text = "";
                txtEntry.Text = PhTime().ToString("MM/dd/yyyy hh:mm tt");
                hfType.Value = "Car";
                btnCar.CssClass = "sp-type-btn active";
                btnMotor.CssClass = "sp-type-btn";
            }
            catch (Exception ex)
            {
                lblErr.Text = "✖ Error recording entry: " + ex.Message;
                lblErr.CssClass = "sp-alert-error";
                lblErr.Visible = true;
                lblMsg.Visible = false;
            }
        }
    }
}