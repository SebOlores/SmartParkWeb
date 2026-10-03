using System;
using System.Data;
using System.Web.UI;

namespace SmartParkWeb
{
    public partial class Payments : Page
    {
        protected void Page_Load(object s, EventArgs e)
        {
            if (Session["user"] == null) Response.Redirect("Login.aspx");
            if (!IsPostBack) LoadPayments("all");
        }

        void LoadPayments(string filter)
        {
            string proc = filter == "today" ? "sp_GetTodayPayments" : "sp_GetAllPayments";
            DataTable dt = DbHelper.ExecProc(proc);
            rptPay.DataSource = dt;
            rptPay.DataBind();
            btnAll.CssClass = filter == "all" ? "sp-tab active" : "sp-tab";
            btnToday.CssClass = filter == "today" ? "sp-tab active" : "sp-tab";
        }

        protected void btnAll_Click(object s, EventArgs e)
            => LoadPayments("all");

        protected void btnToday_Click(object s, EventArgs e)
            => LoadPayments("today");

        protected void btnClear_Click(object s, EventArgs e)
        {
            DbHelper.ExecProc("sp_ClearPayments");
            lblMsg.Text = "✔ Payment history cleared successfully!";
            lblMsg.CssClass = "sp-alert-success";
            lblMsg.Visible = true;
            LoadPayments("all");
        }
    }
}