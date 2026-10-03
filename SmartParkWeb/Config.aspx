<%@ Page Title="Settings" Language="C#" MasterPageFile="~/Site.Master"
   AutoEventWireup="true" CodeBehind="Config.aspx.cs" Inherits="SmartParkWeb.Config" %>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
  <style>
    .sp-alert-success {
      display: block; background: #dcfce7; color: #15803d;
      border: 1px solid #bbf7d0; border-radius: 8px;
      padding: 10px 14px; margin-bottom: 14px;
      font-size: 14px; font-weight: 600;
    }
    .sp-alert-error {
      display: block; background: #fee2e2; color: #dc2626;
      border: 1px solid #fecaca; border-radius: 8px;
      padding: 10px 14px; margin-bottom: 14px;
      font-size: 14px; font-weight: 600;
    }
  </style>
</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
      <div class="sp-page-title">
      <a href="Dashboard.aspx" class="sp-back-btn">
        <i class="fa-solid fa-arrow-left"></i>
      </a>
      <h2>Settings</h2>
    </div>
    <asp:Label ID="lblMsg" runat="server" Visible="false" />
  <!-- PARKING CAPACITY -->
  <div class="sp-config-card">
    <div class="sp-config-head">
      <span class="sp-config-icon"><i class="fa-solid fa-square-parking"></i></span>
      <h3>Parking Capacity</h3>
    </div>
    <div class="sp-form-group">
      <label>Total Parking Slots</label>
      <asp:TextBox ID="txtSlots" runat="server" CssClass="sp-input" TextMode="Number" />
    </div>
    <div style="font-size:13px;color:#6b7280;margin-bottom:14px">
      Currently parked: <asp:Label ID="lblCurrently" runat="server" Text="0" />
    </div>
    <asp:Button ID="btnSlots" runat="server" Text="Save Capacity"
      CssClass="sp-btn-green" OnClick="btnSlots_Click" />
  </div>
  <!-- FLAT RATE -->
  <div class="sp-config-card">
    <div class="sp-config-head">
      <span class="sp-config-icon"><i class="fa-solid fa-peso-sign"></i></span>
      <h3>Flat Rate (₱)</h3>
    </div>
    <div class="sp-rate-grid">
      <div class="sp-form-group">
        <label>Car – Flat Rate</label>
        <asp:TextBox ID="txtCarRate" runat="server" CssClass="sp-input" TextMode="Number" />
      </div>
      <div class="sp-form-group">
        <label>Motor – Flat Rate</label>
        <asp:TextBox ID="txtMotorRate" runat="server" CssClass="sp-input" TextMode="Number" />
      </div>
    </div>
    <asp:Button ID="btnFlatRate" runat="server" Text="Save Flat Rate"
      CssClass="sp-btn-dark" OnClick="btnFlatRate_Click" />
  </div>
  <!-- TRANSACTION REPORT -->
  <div class="sp-config-card">
    <div class="sp-config-head">
      <span class="sp-config-icon"><i class="fa-solid fa-chart-bar"></i></span>
      <h3>Transaction Report</h3>
    </div>
    <div style="font-size:13px;color:#6b7280;margin-bottom:16px;">
      Generate a PDF report of transactions for a selected period.
    </div>
    <div class="sp-form-group">
      <label>Report Period</label>
      <asp:DropDownList ID="ddlReportFilter" runat="server" CssClass="sp-input">
        <asp:ListItem Text="Today"        Value="day"   />
        <asp:ListItem Text="Past 7 Days"  Value="week"  Selected="True" />
        <asp:ListItem Text="Past Month"   Value="month" />
      </asp:DropDownList>
    </div>
    <asp:Button ID="btnGenReport" runat="server" Text="Generate PDF Report"
      CssClass="sp-btn-dark" OnClick="btnGenReport_Click" />
  </div>
  <!-- DANGER ZONE -->
  <div class="sp-danger-card">
    <div class="sp-danger-head">
      <span><i class="fa-solid fa-trash"></i></span><h3>Danger Zone</h3>
    </div>
    <asp:Button ID="btnClear" runat="server" Text="Clear All Data"
      CssClass="sp-btn-red"
      OnClientClick="return confirm('Are you sure? This cannot be undone!');"
      OnClick="btnClear_Click" />
  </div>
</asp:Content>
