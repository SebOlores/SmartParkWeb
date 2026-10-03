<%@ Page Title="Vehicle Entry" Language="C#" MasterPageFile="~/Site.Master"
   AutoEventWireup="true" CodeBehind="VehicleEntry.aspx.cs" Inherits="SmartParkWeb.VehicleEntry" %>

<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="HeadContent">
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
    .req { color: #dc2626; }
  </style>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <div class="sp-page-title">
    <a href="Dashboard.aspx" class="sp-back-btn">
      <i class="fa-solid fa-arrow-left"></i>
    </a>
    <h2>Vehicle Entry</h2>
  </div>

  <div class="sp-card">
    <asp:Label ID="lblMsg" runat="server" Visible="false" />
    <asp:Label ID="lblErr" runat="server" Visible="false" />

    <div class="sp-form-group">
      <label>Plate Number <span class="req">*</span></label>
      <asp:TextBox ID="txtPlate" runat="server"
        CssClass="sp-input" placeholder="ABC 1234" />
    </div>

    <div class="sp-form-group">
      <label>Vehicle Type</label>
      <div class="sp-type-row">
        <asp:LinkButton ID="btnCar" runat="server"
          CssClass="sp-type-btn active" OnClick="btnCar_Click">
          <i class="fa-solid fa-car"></i> Car
        </asp:LinkButton>
        <asp:LinkButton ID="btnMotor" runat="server"
          CssClass="sp-type-btn" OnClick="btnMotor_Click">
          <i class="fa-solid fa-motorcycle"></i> Motor
        </asp:LinkButton>
      </div>
      <asp:HiddenField ID="hfType" runat="server" Value="Car" />
    </div>

    <div class="sp-form-group">
      <label><i class="fa-solid fa-clock" style="margin-right:6px;"></i>Entry Time</label>
      <asp:TextBox ID="txtEntry" runat="server" CssClass="sp-input" ReadOnly="true" />
    </div>

    <div class="sp-form-group">
      <label><i class="fa-solid fa-note-sticky" style="margin-right:6px;"></i>Notes (Optional)</label>
      <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine"
        CssClass="sp-input sp-textarea"
        placeholder="Customer name, special requests, etc." />
    </div>

    <asp:Button ID="btnRecord" runat="server" Text="Record Entry"
      CssClass="sp-btn-green" OnClick="btnRecord_Click" />
  </div>
</asp:Content>