<%@ Page Title="Vehicle Exit" Language="C#" MasterPageFile="~/Site.Master"
   AutoEventWireup="true" CodeBehind="VehicleExit.aspx.cs" Inherits="SmartParkWeb.VehicleExit" %>

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
    .sp-veh-notes {
      font-size: 12px; color: #6b7280;
      margin-top: 2px; font-style: italic;
    }
  </style>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

  <div class="sp-page-title">
    <a href="Dashboard.aspx" class="sp-back-btn">
      <i class="fa-solid fa-arrow-left"></i>
    </a>
    <h2>Vehicle Exit</h2>
  </div>

  <asp:Label ID="lblMsg" runat="server" Visible="false" />

  <div class="sp-search-wrap">
    <span class="sp-search-icon"><i class="fa-solid fa-magnifying-glass"></i></span>
    <asp:TextBox ID="txtSearch" runat="server" CssClass="sp-search"
      placeholder="Search plate number..."
      OnTextChanged="txtSearch_Changed"
      AutoPostBack="true" />
  </div>

  <div class="sp-parked-list">
    <div class="sp-parked-header">Currently Parked</div>
    <asp:Repeater ID="rptParked" runat="server" OnItemCommand="rptParked_Command">
      <ItemTemplate>
        <div class="sp-parked-row">
          <div style="display:flex;align-items:center">
            <div class="sp-veh-icon">
              <%# (string)Eval("VehicleType")=="Motor"
                  ? "<i class='fa-solid fa-motorcycle'></i>"
                  : "<i class='fa-solid fa-car'></i>" %>
            </div>
            <div>
              <div class="sp-veh-plate"><%# Eval("PlateNumber") %></div>
              <div class="sp-veh-duration"><%# Eval("EntryTime") %></div>
              <%# !string.IsNullOrEmpty(Eval("Notes").ToString())
                  ? "<div class='sp-veh-notes'><i class='fa-solid fa-note-sticky'></i> " + Eval("Notes") + "</div>"
                  : "" %>
              <div style="font-size:12px; color:#16a34a; font-weight:600;">
                <%# Convert.ToBoolean(Eval("IsPaid")) ? "<i class='fa-solid fa-check'></i> Paid" : "" %>
              </div>
            </div>
          </div>
          <div class="sp-veh-actions">
            <div class="sp-veh-amount">₱<%# Eval("FeeOwed") %></div>
            <div class="sp-veh-btns">
              <button type="button" class="sp-btn-small-pay"
                onclick="openPayModal('<%# Eval("VehicleId") %>','<%# Eval("PlateNumber") %>','<%# Eval("VehicleType") %>','<%# Eval("FeeOwed") %>','<%# ((DateTime)Eval("EntryTime")).ToString("yyyy-MM-ddTHH:mm:ss") %>')">
                <i class="fa-solid fa-credit-card"></i> Pay
              </button>
              <button type="button" class="sp-btn-small-exit"
                onclick="openExitModal('<%# Eval("VehicleId") %>','<%# Eval("PlateNumber") %>','<%# Eval("VehicleType") %>','<%# Eval("FeeOwed") %>','<%# Eval("IsPaid") %>')">
                <i class="fa-solid fa-right-from-bracket"></i> Exit
              </button>
            </div>
          </div>
        </div>
      </ItemTemplate>
    </asp:Repeater>
  </div>

  <asp:HiddenField ID="hfPayVehicleId"  runat="server" Value="" />
  <asp:HiddenField ID="hfExitVehicleId" runat="server" Value="" />
  <asp:Button ID="btnConfirmPay"  runat="server" Style="display:none" OnClick="btnConfirmPay_Click" />
  <asp:Button ID="btnConfirmExit" runat="server" Style="display:none" OnClick="btnConfirmExit_Click" />

  <%-- PAY MODAL --%>
  <div id="payModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%;
       background:rgba(0,0,0,0.4); z-index:999; align-items:center; justify-content:center;">
    <div style="background:#fff; border-radius:16px; padding:28px 24px;
         width:90%; max-width:340px; margin:auto; margin-top:20vh;">
      <div style="font-size:18px; font-weight:800; margin-bottom:4px;">Process Payment</div>
      <div id="modalPaySub" style="font-size:14px; color:#6b7280; margin-bottom:20px;"></div>
      <div style="background:#f0fdf4; border-radius:12px; padding:20px; text-align:center; margin-bottom:24px;">
        <div style="color:#16a34a; font-weight:700; font-size:14px; margin-bottom:8px;">Amount Due</div>
        <div id="modalPayAmount" style="color:#16a34a; font-size:40px; font-weight:900;"></div>
        <div id="modalPayDuration" style="font-size:13px; color:#6b7280; margin-top:6px;"></div>
      </div>
      <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px;">
        <button type="button" onclick="closePayModal()"
          style="padding:14px; border:1px solid #e5e7eb; border-radius:10px;
                 background:#fff; font-size:15px; font-weight:600; cursor:pointer;">
          Cancel
        </button>
        <button type="button" onclick="confirmPay()"
          style="padding:14px; border:none; border-radius:10px;
                 background:#16a34a; color:white; font-size:15px; font-weight:700; cursor:pointer;">
          Confirm Payment
        </button>
      </div>
    </div>
  </div>

  <%-- EXIT MODAL --%>
  <div id="exitModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%;
       background:rgba(0,0,0,0.4); z-index:999; align-items:center; justify-content:center;">
    <div style="background:#fff; border-radius:16px; padding:28px 24px;
         width:90%; max-width:340px; margin:auto; margin-top:20vh;">
      <div style="font-size:18px; font-weight:800; margin-bottom:4px;">Confirm Exit</div>
      <div id="modalExitSub" style="font-size:14px; color:#6b7280; margin-bottom:20px;"></div>
      <div id="exitUnpaidWarning" style="display:none; background:#fee2e2; border:1px solid #fecaca;
           border-radius:10px; padding:14px; text-align:center; margin-bottom:20px;">
        <div style="color:#dc2626; font-weight:700; font-size:14px;">
          <i class="fa-solid fa-triangle-exclamation"></i> Unpaid
        </div>
        <div id="modalExitAmount" style="color:#dc2626; font-size:36px; font-weight:900;"></div>
        <div style="font-size:12px; color:#6b7280; margin-top:4px;">This vehicle has not paid yet</div>
      </div>
      <div id="exitPaidNote" style="display:none; background:#f0fdf4; border:1px solid #bbf7d0;
           border-radius:10px; padding:14px; text-align:center; margin-bottom:20px;">
        <div style="color:#16a34a; font-weight:700; font-size:16px;">
          <i class="fa-solid fa-check"></i> Already Paid
        </div>
        <div style="font-size:12px; color:#6b7280; margin-top:4px;">Safe to exit</div>
      </div>
      <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px;">
        <button type="button" onclick="closeExitModal()"
          style="padding:14px; border:1px solid #e5e7eb; border-radius:10px;
                 background:#fff; font-size:15px; font-weight:600; cursor:pointer;">
          Cancel
        </button>
        <button type="button" onclick="confirmExit()"
          style="padding:14px; border:none; border-radius:10px;
                 background:#dc2626; color:white; font-size:15px; font-weight:700; cursor:pointer;">
          Confirm Exit
        </button>
      </div>
    </div>
  </div>

  <script>
    var currentPayId  = '';
    var currentExitId = '';

    function openPayModal(vid, plate, type, fee, entryTime) {
      currentPayId = vid;
      document.getElementById('modalPaySub').innerText = plate + ' · ' + type;
      document.getElementById('modalPayAmount').innerText = '₱' + fee;

      var entry     = new Date(entryTime);
      var now       = new Date();
      var diffMs    = now - entry;
      if (diffMs < 0) diffMs = 0;

      var totalMins = Math.floor(diffMs / 60000);
      var days  = Math.floor(totalMins / 1440);
      var hours = Math.floor((totalMins % 1440) / 60);
      var mins  = totalMins % 60;

      var durText = '';
      if (days > 0)       durText = days + 'd ' + hours + 'h ' + mins + 'm';
      else if (hours > 0) durText = hours + 'h ' + mins + 'm';
      else                durText = mins + 'm';

      document.getElementById('modalPayDuration').innerText = 'Duration: ' + durText;
      document.getElementById('payModal').style.display = 'flex';
    }

    function closePayModal() {
      document.getElementById('payModal').style.display = 'none';
      currentPayId = '';
    }
    function confirmPay() {
      document.getElementById('<%= hfPayVehicleId.ClientID %>').value = currentPayId;
      document.getElementById('<%= btnConfirmPay.ClientID %>').click();
    }

    function openExitModal(vid, plate, type, fee, isPaid) {
      currentExitId = vid;
      document.getElementById('modalExitSub').innerText = plate + ' · ' + type;
      document.getElementById('modalExitAmount').innerText = '₱' + fee;
      var paid = isPaid.toString().toLowerCase() === 'true';
      document.getElementById('exitUnpaidWarning').style.display = paid ? 'none'  : 'block';
      document.getElementById('exitPaidNote').style.display      = paid ? 'block' : 'none';
      document.getElementById('exitModal').style.display = 'flex';
    }
    function closeExitModal() {
      document.getElementById('exitModal').style.display = 'none';
      currentExitId = '';
    }
    function confirmExit() {
      document.getElementById('<%= hfExitVehicleId.ClientID %>').value = currentExitId;
      document.getElementById('<%= btnConfirmExit.ClientID %>').click();
      }
  </script>

</asp:Content>
