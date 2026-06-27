<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditNotice.aspx.cs" Inherits="DNB.EditNotice" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head runat="server">
<meta charset="utf-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Edit Notice — Digital Notice Board</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<link rel="stylesheet" href="CSS/site.css"/>
<style>
.upload-box{background:rgba(255,255,255,.03);border:2px dashed var(--border2);border-radius:var(--r);padding:1.5rem;text-align:center;transition:all .2s}
.upload-box:hover{border-color:var(--em);background:var(--em-dim)}
.pin-box{background:rgba(245,158,11,.05);border:1px solid rgba(245,158,11,.2);border-radius:var(--r-sm);padding:1rem 1.25rem}
.curr-img-wrap{background:var(--glass);border:1px solid var(--border2);border-radius:var(--r-sm);padding:.75rem;display:inline-block}
.nc-pdf-link{display:inline-flex;align-items:center;gap:.4rem;background:var(--rose-dim);border:1px solid rgba(244,63,94,.2);color:#fb7185;font-size:.82rem;font-weight:700;padding:.4rem .9rem;border-radius:8px;transition:all .2s}
.nc-pdf-link:hover{background:rgba(244,63,94,.2)}
</style>
<script>!function(){var t=localStorage.getItem("dnb-theme")||"dark";document.documentElement.setAttribute("data-theme",t)}();</script>
</head>
<body>
<form id="form1" runat="server">
<asp:HiddenField ID="hfId" runat="server"/>
<div class="adm-layout">
 <aside class="adm-sidebar" id="sidebar">
 <div class="sidebar-brand">
 <div class="brand-icon" style="width:36px;height:36px;font-size:.85rem;"><i class="fas fa-bullhorn"></i></div>
 <div><div style="font-size:.9rem;font-weight:800;color:#fff;">Notice Board</div><div style="font-size:.58rem;color:rgba(255,255,255,.35);letter-spacing:2px;text-transform:uppercase;">Admin Panel</div></div>
 </div>
 <nav class="sidebar-nav">
 <div class="nav-section">Main</div>
 <a href="AdminDashboard.aspx" class="nav-link-item active"><span class="nav-ico"><i class="fas fa-gauge-high"></i></span>Dashboard</a>
 <a href="AddNotice.aspx" class="nav-link-item"><span class="nav-ico"><i class="fas fa-circle-plus"></i></span>Add Notice</a>
 <a href="Messages.aspx" class="nav-link-item"><span class="nav-ico"><i class="fas fa-envelope"></i></span>Message Center</a>
 <a href="Students.aspx" class="nav-link-item"><span class="nav-ico"><i class="fas fa-users"></i></span>Manage Students</a>
 <div class="nav-section mt-2">System</div>
 <a href="Home.aspx" target="_blank" class="nav-link-item"><span class="nav-ico"><i class="fas fa-arrow-up-right-from-square"></i></span>View Site</a>
 <a href="Logout.aspx" class="nav-link-item nav-link-red"><span class="nav-ico"><i class="fas fa-right-from-bracket"></i></span>Logout</a>
 </nav>
 <div class="sidebar-user">
 <div class="user-av"><asp:Label ID="lblAv" runat="server" Text="A"/></div>
 <div><div class="user-name"><asp:Label ID="lblName" runat="server" Text="Admin"/></div><div class="user-role">Administrator</div></div>
 </div>
 </aside>
 <div class="adm-main-area">
 <div class="adm-topbar">
 <div class="d-flex align-items-center gap-3">
 <button type="button" class="sidebar-toggle" onclick="document.getElementById('sidebar').classList.toggle('open')"><i class="fas fa-bars"></i></button>
 <div>
 <div class="page-title"><i class="fas fa-pen me-2 text-amber"></i>Edit Notice <asp:Label ID="lblId" runat="server"/></div>
 <div class="page-sub">Update the notice details below</div>
 </div>
 </div>
 <a href="AdminDashboard.aspx" class="btn-ed"><i class="fas fa-arrow-left me-1"></i>Back</a>
 </div>
 <div class="adm-content-body">
 <div class="row justify-content-center">
 <div class="col-xl-8 col-lg-10">
 <!-- Breadcrumb -->
 <div class="breadcrumb-nav">
 <a href="AdminDashboard.aspx">Dashboard</a>
 <span class="breadcrumb-sep">/</span>
 <span style="color:var(--text2);">Edit Notice</span>
 </div>

 <asp:Panel ID="pnlOk" runat="server" Visible="false" CssClass="alert-box alert-ok mb-4">
 <i class="fas fa-circle-check me-2"></i><asp:Label ID="lblOk" runat="server"/>
 <div class="mt-2">
 <a href="AdminDashboard.aspx" class="btn-submit btn-blue" style="padding:.45rem 1rem;font-size:.82rem;display:inline-flex;">View All Notices</a>
 </div>
 </asp:Panel>
 <asp:Panel ID="pnlErr" runat="server" Visible="false" CssClass="alert-box alert-err mb-4">
 <i class="fas fa-circle-xmark me-2"></i><asp:Label ID="lblErr" runat="server"/>
 </asp:Panel>

 <div class="data-panel">
 <div class="data-panel-head dark-head">
 <h5 style="color:#fff;margin:0;"><i class="fas fa-pen me-2" style="color:var(--amber);"></i>Edit Notice Details</h5>
 <span style="font-size:.75rem;color:var(--text3);">Changes are saved immediately</span>
 </div>
 <div class="p-4">
 <div class="mb-4">
 <label class="form-lbl">Title <span style="color:var(--rose);">*</span></label>
 <asp:TextBox ID="txtTitle" runat="server" CssClass="form-inp" MaxLength="200" Style="font-weight:600;padding-left:1rem;"/>
 <asp:RequiredFieldValidator runat="server" ControlToValidate="txtTitle" ErrorMessage="Title is required" CssClass="val-msg" Display="Dynamic"/>
 </div>
 <div class="mb-4">
 <label class="form-lbl">Description <span style="color:var(--rose);">*</span></label>
 <asp:TextBox ID="txtDesc" runat="server" CssClass="form-inp" TextMode="MultiLine" Rows="7"/>
 <asp:RequiredFieldValidator runat="server" ControlToValidate="txtDesc" ErrorMessage="Description is required" CssClass="val-msg" Display="Dynamic"/>
 </div>
 <div class="row g-3 mb-4">
 <div class="col-md-6">
 <label class="form-lbl">Category</label>
 <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-inp">
 <asp:ListItem Value="Announcements">Announcements</asp:ListItem>
 <asp:ListItem Value="Exams">Exams</asp:ListItem>
 <asp:ListItem Value="Events">Events</asp:ListItem>
 <asp:ListItem Value="Assignments">Assignments</asp:ListItem>
 <asp:ListItem Value="General">General</asp:ListItem>
 </asp:DropDownList>
 </div>
 <div class="col-md-6 d-flex align-items-end">
 <div class="pin-box w-100">
 <asp:CheckBox ID="chkPinned" runat="server" Text=" Pinned notice" style="color:var(--text);font-weight:700;"/>
 </div>
 </div>
 </div>

 <!-- Current Image -->
 <asp:Panel ID="pnlImg" runat="server" Visible="false" CssClass="mb-3">
 <label class="form-lbl">Current Image</label>
 <div class="curr-img-wrap mb-2">
 <img id="imgCurr" runat="server" src="#" alt="Current" style="max-height:150px;border-radius:8px;display:block;"/>
 </div>
 <asp:CheckBox ID="chkRemoveImg" runat="server" Text=" Remove current image" style="color:var(--text2);font-size:.84rem;"/>
 </asp:Panel>

 <div class="mb-4">
 <label class="form-lbl">Replace Image <span style="color:var(--text3);font-weight:400;text-transform:none;">(Optional)</span></label>
 <div class="upload-box">
 <i class="fas fa-image fa-2x mb-2 d-block" style="color:var(--em2);"></i>
 <asp:FileUpload ID="fuImage" runat="server" CssClass="form-inp" accept="image/*" Style="padding-left:.5rem;"/>
 </div>
 </div>

 <!-- Current PDF -->
 <asp:Panel ID="pnlPDF" runat="server" Visible="false" CssClass="mb-3">
 <label class="form-lbl">Current PDF</label>
 <div class="d-flex align-items-center gap-2 mb-1">
 <a id="lnkPDF" runat="server" href="#" target="_blank" class="nc-pdf-link"><i class="fas fa-file-pdf me-1"></i>View Current PDF</a>
 <asp:CheckBox ID="chkRemovePDF" runat="server" Text=" Remove PDF" style="color:var(--text2);font-size:.84rem;"/>
 </div>
 </asp:Panel>

 <div class="mb-5">
 <label class="form-lbl">Replace PDF / Document <span style="color:var(--text3);font-weight:400;text-transform:none;">(Optional)</span></label>
 <div class="upload-box">
 <i class="fas fa-file-pdf fa-2x mb-2 d-block" style="color:#fb7185;"></i>
 <asp:FileUpload ID="fuPDF" runat="server" CssClass="form-inp" accept=".pdf,.doc,.docx" Style="padding-left:.5rem;"/>
 </div>
 </div>

 <div class="d-flex gap-3 flex-wrap">
 <asp:Button ID="btnSave" runat="server" Text="Save Changes" CssClass="btn-submit px-5" OnClick="btnSave_Click"/>
 <a href="AdminDashboard.aspx" class="btn-outline-custom">Cancel</a>
 </div>
 </div>
 </div>
 </div>
 </div>
 </div>
 </div>
</div>
</form>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script src="Scripts/site.js"></script>
</body></html>
