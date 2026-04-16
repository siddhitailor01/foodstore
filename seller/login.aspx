<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="seller_login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Seller Login - FoodStore</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            /* Food Background Image */
            background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80');
            background-size: cover;
            background-position: center;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-card {
            width: 100%;
            max-width: 420px;
            padding: 40px;
            background: rgba(255, 255, 255, 0.95); /* Slight transparency */
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.3);
            text-align: center;
        }

        .brand-logo {
            width: 80px;
            height: 80px;
            background: #ffebee;
            color: #d32f2f;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px auto;
            font-size: 32px;
        }

        .form-floating > .form-control:focus, .form-floating > .form-control:not(:placeholder-shown) {
            padding-top: 1.625rem;
            padding-bottom: .625rem;
        }

        .form-control {
            border-radius: 10px;
            border: 1px solid #ddd;
            height: 55px;
        }
        .form-control:focus {
            box-shadow: none;
            border-color: #d32f2f;
        }

        .btn-custom {
            background: linear-gradient(45deg, #d32f2f, #ff5252);
            color: white;
            border: none;
            padding: 12px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 16px;
            transition: 0.3s;
            box-shadow: 0 5px 15px rgba(211, 47, 47, 0.3);
        }
        .btn-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(211, 47, 47, 0.4);
            color: white;
        }

        .links a {
            color: #555;
            font-size: 14px;
            transition: 0.3s;
        }
        .links a:hover {
            color: #d32f2f;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container px-4">
            <div class="login-card mx-auto">
                
                <div class="brand-logo">
                    <i class="fas fa-store"></i>
                </div>

                <h3 class="fw-bold mb-1 text-dark">Welcome Back Sellers!</h3>
                <p class="text-muted mb-4 small">Log in to manage your restaurant</p>

                <asp:Label ID="lblMsg" runat="server" CssClass="d-block text-center mb-3 fw-bold small"></asp:Label>

                <div class="form-floating mb-3 text-start">
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="name@example.com" TextMode="Email"></asp:TextBox>
                    <label for="txtEmail"><i class="fas fa-envelope me-2 text-muted"></i>Email Address</label>
                </div>

                <div class="form-floating mb-4 text-start">
                    <asp:TextBox ID="txtPass" runat="server" CssClass="form-control" placeholder="Password" TextMode="Password"></asp:TextBox>
                    <label for="txtPass"><i class="fas fa-lock me-2 text-muted"></i>Password</label>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Log In Dashboard" CssClass="btn btn-custom w-100 mb-3" OnClick="btnLogin_Click" />
                <div class="links d-flex justify-content-between mt-3">
                    <a href="../index.aspx" class="text-decoration-none"><i class="fas fa-arrow-left me-1"></i> Back to Home</a>
                    <a href="register.aspx" class="text-decoration-none fw-bold">Register New Shop</a>
                </div>

            </div>
        </div>
    </form>
</body>
</html>