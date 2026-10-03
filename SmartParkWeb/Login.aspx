<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master"
   AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="SmartParkWeb.Login" %>

<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="HeadContent">
  <style>
    .sp-login-wrap {
      display: flex;
      align-items: center;
      justify-content: center;
      min-height: calc(100vh - 60px);
      padding: 24px;
    }
    .sp-login-card {
      background: #fff;
      border-radius: 16px;
      padding: 36px 32px;
      width: 100%;
      max-width: 420px;
      box-shadow: 0 4px 24px rgba(0,0,0,0.06);
    }
    .sp-login-shield {
      width: 72px; height: 72px;
      background: #dcfce7;
      border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
      font-size: 32px;
      color: #16a34a;
      margin: 0 auto 20px;
    }
    .sp-login-title {
      text-align: center;
      font-size: 26px;
      font-weight: 800;
      margin-bottom: 6px;
    }
    .sp-login-sub {
      text-align: center;
      color: #6b7280;
      font-size: 14px;
      margin-bottom: 24px;
    }
    .sp-alert-error {
      display: block;
      background: #fee2e2;
      color: #dc2626;
      border: 1px solid #fecaca;
      border-radius: 8px;
      padding: 10px 14px;
      margin-bottom: 16px;
      font-size: 14px;
      font-weight: 600;
    }
    .sp-alert-warning {
      display: block;
      background: #fefce8;
      color: #a16207;
      border: 1px solid #fde047;
      border-radius: 8px;
      padding: 10px 14px;
      margin-bottom: 16px;
      font-size: 14px;
      font-weight: 600;
    }
    .sp-form-group { margin-bottom: 16px; }
    .sp-form-group label {
      display: block;
      font-weight: 600;
      font-size: 14px;
      margin-bottom: 6px;
      color: #111827;
    }
    .sp-input {
      width: 100%;
      padding: 12px 14px;
      border: 1px solid #e5e7eb;
      border-radius: 10px;
      font-size: 15px;
      color: #111827;
      box-sizing: border-box;
    }
    .sp-input:focus {
      outline: none;
      border-color: #16a34a;
      box-shadow: 0 0 0 3px rgba(22,163,74,0.1);
    }
    .sp-btn-green {
      width: 100%;
      padding: 14px;
      background: #16a34a;
      color: white;
      border: none;
      border-radius: 10px;
      font-size: 16px;
      font-weight: 700;
      cursor: pointer;
      margin-top: 4px;
    }
    .sp-btn-green:hover { background: #15803d; }
  </style>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <div class="sp-login-wrap">
    <div class="sp-login-card">

      <div class="sp-login-shield">
        <i class="fa-solid fa-shield-halved"></i>
      </div>
      <div class="sp-login-title">Welcome Back</div>
      <div class="sp-login-sub">Enter your credentials to access the system</div>

      <asp:Label ID="lblError" runat="server" Visible="false" />

      <div class="sp-form-group">
        <label><i class="fa-solid fa-user" style="margin-right:6px;"></i>Username</label>
        <asp:TextBox ID="txtUser" runat="server"
          CssClass="sp-input" placeholder="Enter username" />
      </div>

      <div class="sp-form-group">
        <label><i class="fa-solid fa-lock" style="margin-right:6px;"></i>Password</label>
        <asp:TextBox ID="txtPass" runat="server" TextMode="Password"
          CssClass="sp-input" placeholder="••••••••" />
      </div>

      <asp:Button ID="btnLogin" runat="server" Text="Sign In"
        CssClass="sp-btn-green" OnClick="btnLogin_Click" />

    </div>
  </div>
</asp:Content>