using System;
using System.Data;
using System.Web.UI;

namespace SmartParkWeb
{
    public partial class Dashboard : Page
    {
        protected void Page_Load(object s, EventArgs e)
        {
            if (Session["user"] == null) Response.Redirect("Login.aspx");
            if (!IsPostBack) LoadDashboard();
        }

        void LoadDashboard()
        {
            DataTable dt = DbHelper.ExecProc("sp_GetDashboard");
            if (dt.Rows.Count > 0)
            {
                DataRow r = dt.Rows[0];
                lblParked.Text = r["ParkedNow"].ToString();
                lblRevenue.Text = r["TodayRevenue"].ToString();
                lblTotal.Text = r["TotalSlots"].ToString();
                int avail = Convert.ToInt32(r["TotalSlots"]) - Convert.ToInt32(r["ParkedNow"]);
                lblAvail.Text = avail.ToString();
            }

            DataTable pay = DbHelper.ExecProc("sp_GetRecentPayments");
            rptRecent.DataSource = pay;
            rptRecent.DataBind();
        }
    }
}