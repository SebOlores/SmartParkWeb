<%@ Page Title="Payment History" Language="C#" MasterPageFile="~/Site.Master"
   AutoEventWireup="true" CodeBehind="Payments.aspx.cs" Inherits="SmartParkWeb.Payments" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
  <style>
    .sp-alert-success {
      display: block;
      background: #dcfce7;
      color: #15803d;
      border: 1px solid #bbf7d0;
      border-radius: 8px;
      padding: 10px 14px;
      margin-bottom: 14px;
      font-size: 14px;
      font-weight: 600;
    }
    .sp-alert-error {
      display: block;
      background: #fee2e2;
      color: #dc2626;
      border: 1px solid #fecaca;
      border-radius: 8px;
      padding: 10px 14px;
      margin-bottom: 14px;
      font-size: 14px;
      font-weight: 600;
    }
  </style>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

  <div class="sp-page-title">
    <a href="Dashboard.aspx" class="sp-back-btn">←</a>
    <h2>Payment History</h2>
  </div>

  <asp:Label ID="lblMsg" runat="server" Visible="false" />

  <div class="sp-tab-row">
    <asp:LinkButton ID="btnAll" runat="server" CssClass="sp-tab active"
      OnClick="btnAll_Click">All</asp:LinkButton>
    <asp:LinkButton ID="btnToday" runat="server" CssClass="sp-tab"
      OnClick="btnToday_Click">Today</asp:LinkButton>
  </div>

  <div class="sp-card">
    <asp:Repeater ID="rptPay" runat="server">
      <ItemTemplate>
        <div class="sp-pay-row">
          <div>
            <span class="sp-pay-plate"><%# Eval("PlateNumber") %></span>
            <span class="sp-pay-tag <%# (string)Eval("VehicleType")=="Car"?"car":"motor" %>">
              <%# Eval("VehicleType") %></span>
            <div class="sp-pay-meta">
              ⏱ <%# Eval("Duration") %>
              &nbsp;📅 <%# Eval("PaymentDate", "{0:M/d/yyyy}") %>
            </div>
          </div>
          <div class="sp-pay-amount">₱<%# Eval("AmountPaid") %></div>
        </div>
      </ItemTemplate>
    </asp:Repeater>
  </div>

  <div style="margin-top:16px;">
    <asp:Button ID="btnClear" runat="server" Text="🗑 Clear Payment History"
      CssClass="sp-btn-red"
      OnClientClick="return confirm('Are you sure you want to clear all payment history? This cannot be undone!');"
      OnClick="btnClear_Click" />
  </div>

</asp:Content>