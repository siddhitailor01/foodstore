<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/seller/SellerMaster.master" AutoEventWireup="true" CodeFile="profile.aspx.cs" Inherits="seller_profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        /* --- PROFILE CARDS --- */
        .profile-card {
            background: #ffffff;
            border-radius: 12px;
            border: 1px solid #eee;
            box-shadow: 0 5px 20px rgba(0,0,0,0.03);
            overflow: hidden;
            margin-bottom: 20px;
        }

        .profile-header {
            background: linear-gradient(135deg, #d32f2f, #ff5252);
            height: 100px;
        }

        .avatar-container {
            margin-top: -50px;
            text-align: center;
        }

        .avatar-img {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            border: 4px solid #fff;
            background: #f8f9fa;
            object-fit: cover;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .profile-name { font-size: 18px; font-weight: 700; color: #333; margin-top: 10px; }
        .profile-email { font-size: 13px; color: #777; margin-bottom: 15px; }

        .status-badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            background: #e8f5e9; color: #2e7d32; /* Default Active */
        }
        .status-pending { background: #fff8e1; color: #f57f17; }

        /* --- FORM STYLES --- */
        .form-section-title {
            font-size: 15px; font-weight: 600; color: #555;
            border-bottom: 1px solid #f0f0f0; padding-bottom: 10px; margin-bottom: 20px;
        }

        .form-label { font-size: 13px; font-weight: 500; color: #444; }
        .form-control { height: 45px; border-radius: 8px; font-size: 14px; border: 1px solid #e0e0e0; }
        .form-control:focus { border-color: #d32f2f; box-shadow: none; }

        .btn-save {
            background: #d32f2f; color: white; padding: 12px 25px; border: none; border-radius: 8px; font-weight: 600; transition: 0.3s;
        }
        .btn-save:hover { background: #b71c1c; transform: translateY(-2px); }
        /* Purana .avatar-img hata dein aur ye naya lagayein */
.avatar-circle {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    background-color: #ffebee; /* Light Red Background */
    color: #d32f2f;            /* Dark Red Text */
    font-size: 42px;
    font-weight: 800;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto;
    border: 4px solid #fff;
    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    text-transform: uppercase;
}

    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div class="container-fluid py-3">
        
        <div class="row">
            
            <div class="col-md-4">
                <div class="profile-card text-center pb-4">
                    <div class="profile-header"></div>
                  <div class="avatar-container">
    <asp:Label ID="lblAvatarLetter" runat="server" CssClass="avatar-circle"></asp:Label>
</div>
                    
                    <h5 class="profile-name"><asp:Label ID="lblDisplayName" runat="server" Text="Seller Name"></asp:Label></h5>
                    <p class="profile-email"><asp:Label ID="lblDisplayEmail" runat="server" Text="seller@example.com"></asp:Label></p>
                    
                    <asp:Label ID="lblStatusBadge" runat="server" CssClass="status-badge" Text="Active Seller"></asp:Label>

                    <hr class="mx-4 my-3" />

                    <div class="px-4 text-start">
                        <small class="text-muted d-block mb-1"><i class="fas fa-calendar-alt me-2"></i>Joined Date</small>
                        <strong class="text-dark"><asp:Label ID="lblJoinDate" runat="server"></asp:Label></strong>
                    </div>
                </div>
            </div>

            <div class="col-md-8">
                <div class="profile-card p-4">
                    
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0 fw-bold">Edit Profile</h5>
                        <asp:Label ID="lblMsg" runat="server"></asp:Label>
                    </div>

                    <div class="form-section-title">Personal Information</div>
                    
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="form-label">Full Name</label>
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email Address (Read Only)</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control bg-light" ReadOnly="true"></asp:TextBox>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Phone Number</label>
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>

                    <div class="form-section-title">Address & Location</div>

                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="form-label">City</label>
                            <asp:DropDownList ID="ddlCity" runat="server" CssClass="form-control form-select"></asp:DropDownList>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Full Address</label>
                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                        </div>
                    </div>

                    <div class="text-end">
                        <asp:Button ID="btnUpdate" runat="server" Text="Save Changes" CssClass="btn-save" OnClick="btnUpdate_Click" />
                    </div>

                </div>
            </div>

        </div>
    </div>

</asp:Content>