<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master"
   AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="SmartParkWeb.Dashboard" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

  <div class="sp-stat-row">
    <div class="sp-stat-card">
      <div>
        <div class="sp-stat-label">Parked Now</div>
        <div class="sp-stat-value">
          <asp:Label ID="lblParked" runat="server" Text="0" />
        </div>
        <div class="sp-stat-sub">vehicles</div>
      </div>
      <div class="sp-stat-icon">
        <i class="fa-solid fa-car"></i>
      </div>
    </div>
    <div class="sp-stat-card">
      <div>
        <div class="sp-stat-label">Today's Revenue</div>
        <div class="sp-stat-value">₱<asp:Label ID="lblRevenue" runat="server" Text="0" /></div>
        <div class="sp-stat-sub">collected</div>
      </div>
      <div class="sp-stat-icon green">
        <i class="fa-solid fa-peso-sign"></i>
      </div>
    </div>
  </div>

  <div class="sp-avail-card">
    <div>
      <div class="sp-avail-label">Available Spots</div>
      <div class="sp-avail-value"><asp:Label ID="lblAvail" runat="server" Text="0" /></div>
      <div class="sp-avail-sub">
        out of <asp:Label ID="lblTotal" runat="server" Text="30" /> total
      </div>
    </div>
    <div class="sp-p-badge">
      <i class="fa-solid fa-square-parking"></i>
    </div>
  </div>

  <div class="sp-action-row">
    <a href="VehicleEntry.aspx" class="sp-action-card entry">
      <div class="sp-action-icon">
        <i class="fa-solid fa-right-to-bracket"></i>
      </div>
      <span>Vehicle Entry</span>
    </a>
    <a href="VehicleExit.aspx" class="sp-action-card exit">
      <div class="sp-action-icon">
        <i class="fa-solid fa-right-from-bracket"></i>
      </div>
      <span>Vehicle Exit</span>
    </a>
  </div>

  <div class="sp-card">
    <div class="sp-card-header">
      <span class="sp-card-title">Recent Activity</span>
      <a href="Payments.aspx" class="sp-view-all">View All</a>
    </div>
    <asp:Repeater ID="rptRecent" runat="server">
      <ItemTemplate>
        <div class="sp-activity-row">
          <div style="display:flex;align-items:center">
            <div class="sp-check">
              <i class="fa-solid fa-circle-check"></i>
            </div>
            <div>
              <div class="sp-activity-plate"><%# Eval("PlateNumber") %></div>
              <div class="sp-activity-date"><%# Eval("PaymentDate", "{0:M/d/yyyy}") %></div>
            </div>
          </div>
          <div class="sp-amount">₱<%# Eval("AmountPaid") %></div>
        </div>
      </ItemTemplate>
    </asp:Repeater>
  </div>

</asp:Content>