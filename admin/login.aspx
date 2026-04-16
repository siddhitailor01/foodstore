<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="Admin_login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Admin Portal - FoodStore</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

    <style>
        /* --- BACKGROUND ANIMATION --- */
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%); /* Deep Blue Admin Theme */
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            position: relative;
        }

        /* Decorative Floating Shapes */
        .shape {
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.1);
            z-index: 0;
            animation: float 10s infinite ease-in-out;
        }
        .shape-1 { width: 200px; height: 200px; top: -50px; left: -50px; }
        .shape-2 { width: 300px; height: 300px; bottom: -100px; right: -50px; animation-delay: 2s; }
        .shape-3 { width: 100px; height: 100px; top: 40%; right: 20%; background: rgba(255, 255, 255, 0.05); animation-delay: 4s; }

        @keyframes float {
            0% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(20px) rotate(10deg); }
            100% { transform: translateY(0px) rotate(0deg); }
        }

        /* --- GLASS CARD --- */
        .login-card {
            width: 100%;
            max-width: 420px;
            padding: 40px;
            background: rgba(255, 255, 255, 0.95); /* Glass Effect */
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
            position: relative;
            z-index: 10;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .admin-icon-box {
            width: 80px;
            height: 80px;
            background: linear-gradient(45deg, #1e3c72, #2a5298);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: -80px auto 20px auto; /* Half outside the card */
            box-shadow: 0 10px 20px rgba(30, 60, 114, 0.3);
            border: 5px solid rgba(255, 255, 255, 0.2);
        }
        .admin-icon-box i { font-size: 32px; color: white; }

        .brand-title {
            font-size: 24px;
            font-weight: 700;
            color: #1e3c72;
            margin-bottom: 5px;
            letter-spacing: 0.5px;
        }

        /* --- INPUTS --- */
        .input-group-text {
            background: transparent;
            border-right: none;
            color: #1e3c72;
            border-radius: 10px 0 0 10px;
        }
        
        .form-control {
            height: 50px;
            border-left: none;
            border-radius: 0 10px 10px 0;
            font-size: 14px;
        }
        .form-control:focus {
            box-shadow: none;
            border-color: #ced4da;
        }
        .input-group:focus-within .input-group-text,
        .input-group:focus-within .form-control {
            border-color: #1e3c72;
        }

        /* --- BUTTON --- */
        .btn-login {
            background: linear-gradient(45deg, #1e3c72, #2a5298);
            border: none;
            height: 50px;
            border-radius: 30px;
            font-size: 16px;
            font-weight: 600;
            letter-spacing: 1px;
            transition: 0.3s;
            box-shadow: 0 5px 15px rgba(30, 60, 114, 0.3);
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(30, 60, 114, 0.4);
            background: linear-gradient(45deg, #162e58, #22427a);
        }

        /* --- FOOTER --- */
        .login-footer {
            margin-top: 25px;
            font-size: 12px;
            color: #888;
        }
    </style>
</head>
<body>
    
    <div class="shape shape-1"></div>
    <div class="shape shape-2"></div>
    <div class="shape shape-3"></div>

    <form id="form1" runat="server">
        <div class="container px-4">
            <div class="login-card mx-auto">
                
                <div class="admin-icon-box">
                    <i class="fas fa-user-shield"></i>
                </div>

                <h3 class="brand-title">Admin Access</h3>
                <p class="text-muted small mb-4">Secure system login</p>

                <asp:Label ID="lblMsg" runat="server" CssClass="d-block text-danger fw-bold small mb-3"></asp:Label>

                <div class="input-group mb-3">
                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                    <asp:TextBox ID="txtUser" runat="server" CssClass="form-control" placeholder="Username"></asp:TextBox>
                </div>

                <div class="input-group mb-4">
                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                    <asp:TextBox ID="txtPass" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password"></asp:TextBox>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="AUTHENTICATE" CssClass="btn btn-primary btn-login w-100" OnClick="btnLogin_Click" />

                <div class="login-footer">
                    &copy; <%= DateTime.Now.Year %> FoodStore Admin Panel<br />
                    <span class="text-muted">Authorized Personnel Only</span>
                </div>

            </div>
        </div>
    </form>

</body>
</html>