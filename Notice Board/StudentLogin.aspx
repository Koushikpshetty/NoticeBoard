<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentLogin.aspx.cs" Inherits="DNB.StudentLogin" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head runat="server">
<meta charset="utf-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Student Login — Digital Notice Board</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<link rel="stylesheet" href="CSS/site.css"/>
<script>!function(){var t=localStorage.getItem("dnb-theme")||"dark";document.documentElement.setAttribute("data-theme",t)}();</script>
</head>
<body>
<form id="form1" runat="server">
<div class="auth-wrap">
 <div class="auth-card">
 <div class="auth-head auth-head-student">
 <div class="auth-icon auth-icon-student"><i class="fas fa-graduation-cap"></i></div>
 <h2 class="auth-title">Student Login</h2>
 <p class="auth-sub">Sign in to view all official notices</p>
 </div>
 <div class="auth-body">
 <asp:Panel ID="pnlErr" runat="server" Visible="false" CssClass="alert-box alert-err mb-4">
 <i class="fas fa-circle-xmark me-2"></i><asp:Label ID="lblErr" runat="server"/>
 </asp:Panel>
 <div class="mb-4">
 <label class="form-lbl">Username</label>
 <div class="input-wrap">
 <i class="input-icon fas fa-user"></i>
 <asp:TextBox ID="txtUser" runat="server" CssClass="form-inp" placeholder="Enter your username" MaxLength="50"/>
 </div>
 <asp:RequiredFieldValidator runat="server" ControlToValidate="txtUser" ErrorMessage="Username is required" CssClass="val-msg" Display="Dynamic"/>
 </div>
 <div class="mb-5">
 <label class="form-lbl">Password</label>
 <div class="input-wrap">
 <i class="input-icon fas fa-lock"></i>
 <asp:TextBox ID="txtPwd" runat="server" CssClass="form-inp" TextMode="Password" placeholder="Enter your password" MaxLength="100"/>
 </div>
 <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPwd" ErrorMessage="Password is required" CssClass="val-msg" Display="Dynamic"/>
 </div>
 <asp:Button ID="btnLogin" runat="server" Text="Login &amp; View Notices" CssClass="btn-submit btn-teal w-100 mb-4" OnClick="btnLogin_Click"/>
 <div class="text-center" style="font-size:.84rem;">
 <a href="Home.aspx" class="link-back"><i class="fas fa-arrow-left me-1"></i>Back to Home</a>
 <span style="color:var(--text3);margin:0 .6rem;">|</span>
 <a href="StudentRegister.aspx" class="link-teal">Create Account</a>
 <span style="color:var(--text3);margin:0 .6rem;">|</span>
 <a href="AdminLogin.aspx" class="link-red">Admin Login</a>
 </div>
 </div>
 </div>
</div>
</form>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script src="Scripts/site.js"></script>
</body></html>
