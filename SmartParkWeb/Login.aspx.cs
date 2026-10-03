using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace SmartParkWeb
{
    public partial class Login : Page
    {
        protected void Page_Load(object s, EventArgs e)
        {
            // Only clear session on fresh visit, not on form submit
            if (!IsPostBack)
            {
                Session.Clear();
                Session.Abandon();
            }
        }

        protected void btnLogin_Click(object s, EventArgs e)
        {
            string user = txtUser.Text.Trim();
            string pass = txtPass.Text.Trim();

            if (string.IsNullOrEmpty(user) || string.IsNullOrEmpty(pass))
            {
                lblError.Text = "⚠ Please enter both username and password.";
                lblError.CssClass = "sp-alert-warning";
                lblError.Visible = true;
                return;
            }

            DataTable dt = DbHelper.ExecProc("sp_Login",
                new SqlParameter("@Username", user),
                new SqlParameter("@Password", pass));

            if (dt.Rows.Count > 0)
            {
                Session["user"] = dt.Rows[0]["Username"].ToString();
                Session["role"] = dt.Rows[0]["Role"].ToString();
                Response.Redirect("Dashboard.aspx");
            }
            else
            {
                lblError.Text = "✖ Incorrect username or password.";
                lblError.CssClass = "sp-alert-error";
                lblError.Visible = true;
                txtPass.Text = "";
            }
        }
    }
}