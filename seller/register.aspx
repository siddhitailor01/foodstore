<%@ Page Language="C#" AutoEventWireup="true" CodeFile="register.aspx.cs" Inherits="seller_register" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Partner Registration</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)), url('https://images.unsplash.com/photo-1555396273-367ea4eb4db5?ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80');
            background-size: cover;
            background-position: center;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* --- CARD STYLE (Ultra Compact) --- */
        .register-card {
            width: 100%;
            max-width: 360px; /* Bahut kam width kar di */
            padding: 25px 20px;
            background: rgba(255, 255, 255, 0.98);
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
        }

        .brand-icon {
            width: 50px;
            height: 50px;
            background: #ffebee;
            color: #d32f2f;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            margin-bottom: 10px;
        }

        /* --- INPUTS KO CHHOTA KARNA --- */
        .form-control, .form-select {
            height: 40px !important; /* Height kam ki */
            font-size: 13px;
            border-radius: 6px;
            padding-top: 15px !important; /* Text position adjust */
            padding-bottom: 0px !important;
        }
        
        /* Floating Label Text Size & Position */
        .form-floating > label {
            padding: 8px 12px;
            font-size: 12px;
            height: 100%;
            display: flex;
            align-items: center;
            opacity: 0.7;
        }

        .form-floating > .form-control:focus ~ label,
        .form-floating > .form-control:not(:placeholder-shown) ~ label {
            transform: scale(0.85) translateY(-0.5rem) translateX(0.15rem);
            opacity: 1;
            color: #d32f2f;
        }

        /* --- BUTTON STYLE --- */
        .btn-custom {
            background: #d32f2f;
            color: white;
            border: none;
            padding: 8px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 14px;
            transition: 0.3s;
            margin-top: 10px;
        }
        .btn-custom:hover {
            background: #b71c1c;
            color: white;
        }
        
        /* Textarea Adjustment */
        textarea.form-control {
            height: 60px !important;
            padding-top: 20px !important;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="register-card mx-auto">
            
            <div class="text-center mb-3">
                <div class="brand-icon"><i class="fas fa-handshake"></i></div>
                <h5 class="fw-bold m-0 text-dark">Join Us</h5>
                <small class="text-muted" style="font-size: 11px;">Create Partner Account</small>
            </div>

            <asp:Label ID="lblMsg" runat="server" CssClass="d-block text-center mb-2 fw-bold text-danger" Font-Size="11px"></asp:Label>

            <div class="row g-2">
                
                <div class="col-12">
                    <div class="form-floating">
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Name"></asp:TextBox>
                        <label>Owner Name</label>
                    </div>
                </div>

                <div class="col-12">
                    <div class="form-floating">
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Email" TextMode="Email"></asp:TextBox>
                        <label>Email ID</label>
                    </div>
                </div>

                <div class="col-6">
                    <div class="form-floating">
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="Phone"></asp:TextBox>
                        <label>Phone</label>
                    </div>
                </div>

                <div class="col-6">
                    <div class="form-floating">
                        <asp:DropDownList ID="ddlCity" runat="server" CssClass="form-select">
                            <asp:ListItem Text="City" Value="0"></asp:ListItem>
                        </asp:DropDownList>
                        <label>City</label>
                    </div>
                </div>

                <div class="col-12">
                    <div class="form-floating">
                        <asp:TextBox ID="txtPass" runat="server" CssClass="form-control" placeholder="Pass" TextMode="Password"></asp:TextBox>
                        <label>Password</label>
                    </div>
                </div>

                <div class="col-12">
                    <div class="form-floating">
                        <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" placeholder="Addr"></asp:TextBox>
                        <label>Shop Address</label>
                    </div>
                </div>
            </div>

            <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn btn-custom w-100" OnClick="btnRegister_Click" />

            <div class="text-center mt-3">
                <span class="text-muted" style="font-size: 12px;">Have an account? </span>
                <a href="Login.aspx" class="text-danger fw-bold text-decoration-none" style="font-size: 12px;">Login</a>
            </div>

        </div>
    </form>
</body>
</html>