<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentRegister.aspx.cs" Inherits="DNB.StudentRegister" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head runat="server">
<meta charset="utf-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Create Account — Digital Notice Board</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<link rel="stylesheet" href="CSS/site.css"/>
<script>!function(){var t=localStorage.getItem("dnb-theme")||"dark";document.documentElement.setAttribute("data-theme",t)}();</script>
</head>
<body>
<form id="form1" runat="server">
<div class="auth-wrap">
 <div class="auth-card" style="max-width:490px;">
 <div class="auth-head auth-head-student">
 <div class="auth-icon auth-icon-student"><i class="fas fa-user-plus"></i></div>
 <h2 class="auth-title">Create Account</h2>
 <p class="auth-sub">Register to access official notices</p>
 </div>
 <div class="auth-body">
 <asp:Panel ID="pnlOk" runat="server" Visible="false" CssClass="alert-box alert-ok mb-4">
 <i class="fas fa-circle-check me-2"></i><asp:Label ID="lblOk" runat="server"/>
 <div class="mt-2"><a href="StudentLogin.aspx" class="btn-submit btn-teal" style="padding:.5rem 1.25rem;font-size:.84rem;display:inline-flex;">Go to Login</a></div>
 </asp:Panel>
 <asp:Panel ID="pnlErr" runat="server" Visible="false" CssClass="alert-box alert-err mb-4">
 <i class="fas fa-circle-xmark me-2"></i><asp:Label ID="lblErr" runat="server"/>
 </asp:Panel>
 <div class="mb-3">
 <label class="form-lbl">Full Name <span style="color:var(--rose);">*</span></label>
 <div class="input-wrap">
 <i class="input-icon fas fa-id-card"></i>
 <asp:TextBox ID="txtFullName" runat="server" CssClass="form-inp" placeholder="Your full name" MaxLength="100"/>
 </div>
 <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFullName" ErrorMessage="Full name is required" CssClass="val-msg" Display="Dynamic"/>
 </div>
 <div class="mb-3">
 <label class="form-lbl">Username <span style="color:var(--rose);">*</span></label>
 <div class="input-wrap">
 <i class="input-icon fas fa-user"></i>
 <asp:TextBox ID="txtUser" runat="server" CssClass="form-inp" placeholder="Choose a username" MaxLength="50"/>
 </div>
 <asp:RequiredFieldValidator runat="server" ControlToValidate="txtUser" ErrorMessage="Username is required" CssClass="val-msg" Display="Dynamic"/>
 <asp:RegularExpressionValidator runat="server" ControlToValidate="txtUser" ValidationExpression="^[a-zA-Z0-9_]{3,50}$" ErrorMessage="3–50 chars, letters/numbers/underscore only" CssClass="val-msg" Display="Dynamic"/>
 </div>
 <div class="mb-3">
 <label class="form-lbl">Email Address <span style="color:var(--rose);">*</span></label>
 <div class="input-wrap">
 <i class="input-icon fas fa-envelope"></i>
 <asp:TextBox ID="txtEmail" runat="server" CssClass="form-inp" placeholder="your@email.com" MaxLength="150" TextMode="Email"/>
 </div>
 <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required" CssClass="val-msg" Display="Dynamic"/>
 <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail" ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" ErrorMessage="Please enter a valid email" CssClass="val-msg" Display="Dynamic"/>
 </div>
 <div class="mb-3">
 <label class="form-lbl">Password <span style="color:var(--rose);">*</span></label>
 <div class="input-wrap">
 <i class="input-icon fas fa-lock"></i>
 <asp:TextBox ID="txtPwd" runat="server" CssClass="form-inp" TextMode="Password" placeholder="Minimum 6 characters" MaxLength="100"/>
 </div>
 <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPwd" ErrorMessage="Password is required" CssClass="val-msg" Display="Dynamic"/>
 <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPwd" ValidationExpression="^.{6,100}$" ErrorMessage="Password must be at least 6 characters" CssClass="val-msg" Display="Dynamic"/>
 </div>
 <div class="mb-5">
 <label class="form-lbl">Confirm Password <span style="color:var(--rose);">*</span></label>
 <div class="input-wrap">
 <i class="input-icon fas fa-lock-open"></i>
 <asp:TextBox ID="txtConfirm" runat="server" CssClass="form-inp" TextMode="Password" placeholder="Re-enter your password" MaxLength="100"/>
 </div>
 <asp:RequiredFieldValidator runat="server" ControlToValidate="txtConfirm" ErrorMessage="Please confirm your password" CssClass="val-msg" Display="Dynamic"/>
 <asp:CompareValidator runat="server" ControlToValidate="txtConfirm" ControlToCompare="txtPwd" ErrorMessage="Passwords do not match" CssClass="val-msg" Display="Dynamic"/>
 </div>
 <asp:Button ID="btnRegister" runat="server" Text="Create My Account" CssClass="btn-submit btn-teal w-100 mb-4" OnClick="btnRegister_Click"/>
 <div class="text-center" style="font-size:.84rem;">
 <a href="Home.aspx" class="link-back"><i class="fas fa-arrow-left me-1"></i>Back to Home</a>
 <span style="color:var(--text3);margin:0 .6rem;">|</span>
 <a href="StudentLogin.aspx" class="link-teal">Already registered? Login</a>
 </div>
 </div>
 </div>
</div>
</form>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script src="Scripts/site.js"></script>
</body></html>
