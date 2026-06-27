<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentDashboard.aspx.cs" Inherits="DNB.StudentDashboard" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head runat="server">
<meta charset="utf-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Student Dashboard — Digital Notice Board</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<link rel="stylesheet" href="CSS/site.css"/>
<script>!function(){var t=localStorage.getItem("dnb-theme")||"dark";document.documentElement.setAttribute("data-theme",t)}();</script>
</head>
<body>
<form id="form1" runat="server">
<asp:HiddenField ID="hfNoticeId" runat="server"/>
<asp:HiddenField ID="hfNoticeTitle" runat="server"/>

<!-- NAV -->
<nav class="site-nav">
 <div class="container-fluid px-4 d-flex align-items-center justify-content-between flex-wrap gap-2">
 <a class="nav-brand" href="StudentDashboard.aspx">
 <div class="brand-icon"><i class="fas fa-bullhorn"></i></div>
 <div><div class="brand-title">Digital Notice Board</div><div class="brand-sub">Student Portal</div></div>
 </a>
 <div class="d-flex align-items-center gap-2 flex-wrap">
 <a href="MyMessages.aspx" class="nav-pill" style="position:relative;">
 <i class="fas fa-envelope me-1"></i>My Messages
 <asp:Label ID="lblNewReplies" runat="server" Visible="false"
 style="position:absolute;top:-7px;right:-7px;background:var(--rose);color:#fff;font-size:.6rem;font-weight:800;border-radius:50%;width:18px;height:18px;display:flex;align-items:center;justify-content:center;box-shadow:0 2px 8px rgba(244,63,94,.5);"/>
 </a>
 <button type="button" class="theme-toggle" id="modeToggle" title="Toggle light/dark">
 <i class="fas fa-sun"></i>
 </button>
 <div class="stu-badge">
 <div class="stu-av"><asp:Label ID="lblAv" runat="server" Text="S"/></div>
 <span class="stu-name"><asp:Label ID="lblFirstName" runat="server" Text="Student"/></span>
 </div>
 <a href="Logout.aspx" class="btn-nav-admin"><i class="fas fa-right-from-bracket"></i> Logout</a>
 </div>
 </div>
</nav>

<!-- BANNER -->
<div class="stu-banner">
 <div class="container py-4 text-center" style="position:relative;z-index:1;">
 <h2 class="stu-welcome">Welcome back, <asp:Label ID="lblName" runat="server" Text="Student"/>!</h2>
 <p class="stu-sub mb-4">All official notices from the administration</p>
 <div class="d-flex gap-3 justify-content-center flex-wrap">
 <div class="stu-stat">
 <div class="stu-num"><asp:Label ID="lblNotices" runat="server" Text="0"/></div>
 <div class="stu-lbl">Total Notices</div>
 </div>
 <div class="stu-stat">
 <div class="stu-num" style="color:var(--cyan);"><asp:Label ID="lblToday" runat="server" Text="0"/></div>
 <div class="stu-lbl">Posted Today</div>
 </div>
 <div class="stu-stat">
 <div class="stu-num" style="color:var(--blue2);"><asp:Label ID="lblStudents" runat="server" Text="0"/></div>
 <div class="stu-lbl">Students</div>
 </div>
 </div>
 </div>
</div>

<div class="container py-4">

 <!-- New reply notification -->
 <asp:Panel ID="pnlNewReply" runat="server" Visible="false">
 <div class="notif-banner">
 <div class="notif-dot"></div>
 <div>
 <strong style="color:var(--em2);font-weight:800;"> Admin has replied to your message(s)!</strong>
 <a href="MyMessages.aspx" class="ms-2 link-teal fw-bold">View Replies →</a>
 </div>
 </div>
 </asp:Panel>

 <!-- Search & Filters -->
 <div class="search-bar">
 <div class="row g-2 align-items-center">
 <div class="col-md-5">
 <div class="search-icon-wrap">
 <i class="fas fa-search"></i>
 <asp:TextBox ID="txtSearch" runat="server" CssClass="search-inp" placeholder="Search notices... (Press / to focus)"/>
 </div>
 </div>
 <div class="col-md-5">
 <div class="d-flex gap-2 flex-wrap">
 <asp:LinkButton ID="btnAll" runat="server" CssClass="filter-btn active" OnClick="Filter_Click" CommandArgument="All" data-cat="All" CausesValidation="false"><i class="fas fa-th-large me-1"></i>All</asp:LinkButton>
 <asp:LinkButton ID="btnAnn" runat="server" CssClass="filter-btn" OnClick="Filter_Click" CommandArgument="Announcements" data-cat="Announcements" CausesValidation="false"><i class="fas fa-bullhorn me-1"></i>Announce</asp:LinkButton>
 <asp:LinkButton ID="btnExam" runat="server" CssClass="filter-btn" OnClick="Filter_Click" CommandArgument="Exams" data-cat="Exams" CausesValidation="false"><i class="fas fa-file-alt me-1"></i>Exams</asp:LinkButton>
 <asp:LinkButton ID="btnEvents" runat="server" CssClass="filter-btn" OnClick="Filter_Click" CommandArgument="Events" data-cat="Events" CausesValidation="false"><i class="fas fa-calendar me-1"></i>Events</asp:LinkButton>
 <asp:LinkButton ID="btnAssign" runat="server" CssClass="filter-btn" OnClick="Filter_Click" CommandArgument="Assignments" data-cat="Assignments" CausesValidation="false"><i class="fas fa-book me-1"></i>Assign</asp:LinkButton>
 </div>
 </div>
 <div class="col-md-2">
 <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn-submit btn-teal w-100" OnClick="btnSearch_Click" Style="padding:.58rem 1rem;font-size:.85rem;"/>
 </div>
 </div>
 </div>


  <%-- Required by code-behind --%>
  <asp:Label ID="lblCount" runat="server" Text="0" style="display:none;"/>

  <div class="sort-bar">
    <span class="notice-count-badge"><i class="fas fa-newspaper me-1"></i><span id="totalCount">0</span> notices</span>
    <div class="d-flex align-items-center gap-2 flex-wrap">
      <span class="sort-label"><i class="fas fa-sort me-1"></i>Sort:</span>
      <select class="sort-select" id="sortSelect" onchange="sortNotices(this.value)">
        <option value="default">Pinned First</option>
        <option value="newest">Newest First</option>
        <option value="oldest">Oldest First</option>
        <option value="alpha">A to Z</option>
      </select>
      <button type="button" class="btn-print" onclick="window.print()"><i class="fas fa-print me-1"></i>Print</button>
    </div>
  </div>

 <!-- Empty state (ID must match code-behind: pnlEmpty) -->
 <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
 <div class="empty-state">
 <div class="empty-icon"><i class="fas fa-search"></i></div>
 <div class="empty-title">No notices found</div>
 <p class="empty-sub">Try different keywords or select a different category.</p>
 </div>
 </asp:Panel>

 <!-- Notices Repeater -->
 <asp:Repeater ID="rpt" runat="server">
 <HeaderTemplate><div class="row g-4"></HeaderTemplate>
 <ItemTemplate>
 <div class="col-md-6 col-lg-4">
  <div class='notice-card <%# Convert.ToBoolean(Eval("IsPinned")) ? "pinned" : "" %>'
  role="button" tabindex="0"
  data-title='<%# Server.HtmlEncode(Eval("Title").ToString()).Replace("'","&#39;") %>'
  data-desc='<%# Server.HtmlEncode(Eval("Description").ToString()).Replace("'","&#39;") %>'
  data-date='<%# DataBinder.Eval(Container.DataItem,"UploadDate","{0:MMM dd, yyyy}") %>'
  data-author='<%# Server.HtmlEncode(Eval("UploadedByAdmin").ToString()).Replace("'","&#39;") %>'
  data-image='<%# string.IsNullOrEmpty(Eval("ImagePath") as string) ? "" : ResolveUrl(Eval("ImagePath").ToString()) %>'>
 <%# GetNoticeImage(Eval("ImagePath") as string) %>
 <div class="nc-body">
 <div class="nc-meta">
 <%# GetCatBadge(Eval("Category").ToString()) %>
 <%# Convert.ToBoolean(Eval("IsPinned")) ? "<span class='pinned-badge'><i class='fas fa-thumbtack me-1'></i>Pinned</span>" : "" %>
 <span class="nc-date ms-auto"><i class="fas fa-calendar-alt me-1"></i><%# DataBinder.Eval(Container.DataItem,"UploadDate","{0:MMM dd, yyyy}") %></span>
 </div>
 <h5 class="nc-title"><%# Server.HtmlEncode(Eval("Title").ToString()) %></h5>
 <p class="nc-desc"><%# GetDescription(Eval("Description").ToString()) %></p>
 <%# GetPDFLink(Eval("PDFPath") as string) %>
 </div>
 <div class="nc-footer">
 <span class="nc-by"><i class="fas fa-user-tie me-1"></i><%# Server.HtmlEncode(Eval("UploadedByAdmin").ToString()) %></span>
 <button type="button" class="btn-msg-admin"
 onclick="openMsgModal('<%# Eval("NoticeID") %>','<%# Server.HtmlEncode(Eval("Title").ToString()).Replace("'","&#39;") %>')">
 <i class="fas fa-envelope"></i> Message
 </button>
 </div>
 </div>
 </div>
 </ItemTemplate>
 <FooterTemplate></div></FooterTemplate>
 </asp:Repeater>
</div>

 <!-- Notice Modal -->
 <div class="modal fade" id="noticeModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
   <div class="modal-content">
    <div class="modal-header">
     <h5 class="modal-title" id="noticeModalTitle"></h5>
     <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
    </div>
    <div class="modal-body p-4">
     <div class="mb-3">
      <img id="noticeModalImg" class="img-fluid w-100 rounded" alt="Notice Image" style="display:none;" />
      <div id="noticeModalPlaceholder" class="nc-img-ph" style="display:none;height:260px;"><i class="fas fa-newspaper"></i></div>
     </div>
     <div class="d-flex align-items-center gap-3 flex-wrap mb-2">
      <span class="nc-date" id="noticeModalDate"></span>
      <span class="nc-by" id="noticeModalAuthor"></span>
     </div>
     <p id="noticeModalDesc" class="mb-0"></p>
    </div>
   </div>
  </div>
 </div>

 <!-- Message Modal -->
<div class="modal fade" id="msgModal" tabindex="-1">
 <div class="modal-dialog modal-dialog-centered">
 <div class="modal-content">
 <div class="modal-header">
 <h5 class="modal-title"><i class="fas fa-envelope me-2" style="color:var(--em2);"></i>Message Admin</h5>
 <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
 </div>
 <div class="modal-body p-4">
 <asp:Panel ID="pnlMsgOk" runat="server" Visible="false" CssClass="alert-box alert-ok mb-3">
 <i class="fas fa-circle-check me-2"></i><asp:Label ID="lblMsgOk" runat="server"/>
 </asp:Panel>
 <asp:Panel ID="pnlMsgErr" runat="server" Visible="false" CssClass="alert-box alert-err mb-3">
 <asp:Label ID="lblMsgErr" runat="server"/>
 </asp:Panel>
 <div class="mb-3">
 <label class="form-lbl">Regarding Notice</label>
 <asp:TextBox ID="txtNoticeName" runat="server" CssClass="form-inp" ReadOnly="true" Style="padding-left:1rem;opacity:.6;"/>
 </div>
 <div class="mb-3">
 <label class="form-lbl">Subject <span style="color:var(--rose);">*</span></label>
 <asp:TextBox ID="txtSubject" runat="server" CssClass="form-inp" placeholder="Enter subject" MaxLength="200" Style="padding-left:1rem;"/>
 <asp:RequiredFieldValidator runat="server" ControlToValidate="txtSubject" ErrorMessage="Subject is required" CssClass="val-msg" Display="Dynamic" ValidationGroup="msg"/>
 </div>
 <div class="mb-3">
 <label class="form-lbl">Message <span style="color:var(--rose);">*</span></label>
 <asp:TextBox ID="txtMessage" runat="server" CssClass="form-inp" TextMode="MultiLine" Rows="5" placeholder="Type your message to the admin..."/>
 <asp:RequiredFieldValidator runat="server" ControlToValidate="txtMessage" ErrorMessage="Message cannot be empty" CssClass="val-msg" Display="Dynamic" ValidationGroup="msg"/>
 </div>
 </div>
 <div class="modal-footer">
 <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">Cancel</button>
 <asp:Button ID="btnSendMsg" runat="server" Text="Send Message" CssClass="btn-submit btn-teal" OnClick="btnSendMsg_Click" ValidationGroup="msg"/>
 </div>
 </div>
 </div>
</div>

<footer class="site-footer mt-5">
 <div class="container d-flex justify-content-between align-items-center flex-wrap gap-2 py-4">
 <p class="footer-text">&copy; <%=DateTime.Now.Year%> Digital Notice Board.</p>
 <div class="d-flex gap-3">
 <a href="MyMessages.aspx" class="footer-text"><i class="fas fa-envelope me-1"></i>My Messages</a>
 <a href="Logout.aspx" class="footer-text"><i class="fas fa-right-from-bracket me-1"></i>Logout</a>
 </div>
 </div>
</footer>
</form>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script src="Scripts/site.js"></script>
<script>
function sortNotices(v){
  var g=document.querySelector(".row.g-4");if(!g)return;
  var cols=Array.from(g.querySelectorAll("[class*=col-]"));
  cols.sort(function(a,b){
    var ca=a.querySelector(".notice-card"),cb=b.querySelector(".notice-card");
    if(!ca||!cb)return 0;
    var pA=ca.classList.contains("pinned")?1:0,pB=cb.classList.contains("pinned")?1:0;
    var tA=(ca.querySelector(".nc-title")||{}).textContent||"";
    var tB=(cb.querySelector(".nc-title")||{}).textContent||"";
    var dA=(ca.querySelector(".nc-date")||{}).textContent||"";
    var dB=(cb.querySelector(".nc-date")||{}).textContent||"";
    if(v==="default")return pB-pA;
    if(v==="alpha")return tA.localeCompare(tB);
    if(v==="newest")return dB.localeCompare(dA);
    if(v==="oldest")return dA.localeCompare(dB);
    return 0;
  });
  cols.forEach(function(c){g.appendChild(c)});
}

var _msgModal;
var _noticeModal;
function openNoticeModal(card){
  var title = card.getAttribute("data-title") || "";
  var desc = card.getAttribute("data-desc") || "";
  var date = card.getAttribute("data-date") || "";
  var author = card.getAttribute("data-author") || "";
  var imgSrc = card.getAttribute("data-image") || "";
  var titleEl = document.getElementById("noticeModalTitle");
  var descEl = document.getElementById("noticeModalDesc");
  var dateEl = document.getElementById("noticeModalDate");
  var authorEl = document.getElementById("noticeModalAuthor");
  var imgEl = document.getElementById("noticeModalImg");
  var phEl = document.getElementById("noticeModalPlaceholder");
  if(titleEl) titleEl.textContent = title;
  if(descEl) descEl.textContent = desc;
  if(dateEl) dateEl.innerHTML = "<i class='fas fa-calendar-alt me-1'></i>" + date;
  if(authorEl) authorEl.innerHTML = "<i class='fas fa-user-tie me-1'></i>" + author;
  if(imgSrc){
    if(imgEl){ imgEl.src = imgSrc; imgEl.style.display = "block"; }
    if(phEl) phEl.style.display = "none";
  } else {
    if(imgEl){ imgEl.removeAttribute("src"); imgEl.style.display = "none"; }
    if(phEl) phEl.style.display = "flex";
  }
  if(!_noticeModal) _noticeModal = new bootstrap.Modal(document.getElementById("noticeModal"));
  _noticeModal.show();
}

document.addEventListener("DOMContentLoaded", function(){
  document.querySelectorAll(".notice-card").forEach(function(card){
    card.addEventListener("click", function(e){
      if(e.target.closest(".btn-msg-admin") || e.target.closest(".nc-pdf-link")) return;
      openNoticeModal(card);
    });
    card.addEventListener("keydown", function(e){
      if(e.key === "Enter" || e.key === " "){
        e.preventDefault();
        openNoticeModal(card);
      }
    });
  });
});

function openMsgModal(nid, ntitle) {
 document.getElementById('<%=hfNoticeId.ClientID%>').value = nid;
 document.getElementById('<%=hfNoticeTitle.ClientID%>').value = ntitle;
 document.getElementById('<%=txtNoticeName.ClientID%>').value = ntitle;
 document.getElementById('<%=txtSubject.ClientID%>').value = '';
 document.getElementById('<%=txtMessage.ClientID%>').value = '';
 if(!_msgModal) _msgModal = new bootstrap.Modal(document.getElementById('msgModal'));
 _msgModal.show();
}
<%if(ViewState["keepModal"]!= null && (bool)ViewState["keepModal"]){%>
window.addEventListener('load',function(){
 if(!_msgModal) _msgModal = new bootstrap.Modal(document.getElementById('msgModal'));
 _msgModal.show();
});
<%}%>

// Sync totalCount from server-rendered lblCount (reliable after postback)
window.addEventListener("load", function(){
  var serverCount = document.getElementById('<%=lblCount.ClientID%>');
  var el = document.getElementById("totalCount");
  if(el && serverCount) el.textContent = serverCount.textContent || serverCount.innerText || "0";
});

// Restore active filter button state after postback
(function(){
  var activeFilter = '<%= ViewState["ActiveFilter"] ?? "All" %>';
  var buttons = document.querySelectorAll('.filter-btn');
  buttons.forEach(function(btn){
    btn.classList.remove('active');
    var arg = btn.getAttribute('data-cat') || btn.textContent.trim().replace(/\s+/g,' ');
    if(btn.getAttribute('data-cat') === activeFilter) btn.classList.add('active');
  });
  // Fallback: mark All active if none matched
  var anyActive = document.querySelector('.filter-btn.active');
  if(!anyActive){
    var allBtn = document.getElementById('<%=btnAll.ClientID%>');
    if(allBtn) allBtn.classList.add('active');
  }
})();
</script>
</body></html>
