<%@ Page Title="Restaurant Details" Language="C#" MasterPageFile="~/seller/SellerMaster.master" AutoEventWireup="true" CodeFile="restaurantdetails.aspx.cs" Inherits="seller_restaurantdetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        /* --- GENERAL --- */
        .page-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 20px;
        }
        
        /* --- CARDS --- */
        .detail-card {
            background: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.02);
        }

        .card-heading {
            font-size: 16px; font-weight: 700; color: #333;
            border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 15px;
            text-transform: uppercase; letter-spacing: 0.5px;
        }

        /* --- IMAGES --- */
        .main-cover-box {
            width: 100%; height: 300px;
            border-radius: 8px; overflow: hidden;
            background-color: #f0f0f0; border: 1px solid #ddd;
        }
        .main-cover-img { width: 100%; height: 100%; object-fit: cover; }

        .dish-box {
            display: flex; align-items: center; gap: 15px;
            background: #f9f9f9; padding: 10px; border-radius: 8px; border: 1px solid #eee;
        }
        .dish-thumb { width: 70px; height: 70px; border-radius: 50%; object-fit: cover; border: 2px solid #fff; shadow: 0 2px 5px rgba(0,0,0,0.1); }

        .menu-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; }
        .menu-item img { width: 100%; height: 80px; object-fit: cover; border-radius: 4px; border: 1px solid #ddd; transition: 0.2s; cursor: pointer; }
        .menu-item img:hover { transform: scale(1.05); border-color: #d32f2f; }

        /* --- INFO LIST --- */
        .info-list { list-style: none; padding: 0; margin: 0; }
        .info-list li {
            display: flex; justify-content: space-between;
            padding: 10px 0; border-bottom: 1px solid #f5f5f5;
            font-size: 14px;
        }
        .info-list li:last-child { border-bottom: none; }
        .info-label { color: #777; font-weight: 500; }
        .info-val { color: #333; font-weight: 600; text-align: right; }

        /* --- BADGES --- */
        .facility-pill {
            display: inline-block; background: #eef2f6; color: #455a64;
            padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 500;
            margin: 0 5px 5px 0; border: 1px solid #e0e0e0;
        }

        /* --- MAP --- */
        .map-container iframe { width: 100%; height: 250px; border-radius: 8px; border: 0; }

        /* Button */
        .btn-edit-custom {
            background: #d32f2f; color: white; padding: 8px 20px; border-radius: 5px; text-decoration: none; font-weight: 600; font-size: 14px;
        }
        .btn-edit-custom:hover { background: #b71c1c; color: white; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div class="container-fluid px-0">
        
        <div class="page-header">
            <div>
                <h4 class="mb-1 fw-bold text-dark">Restaurant Details</h4>
                <a href="MyRestaurants.aspx" class="text-secondary text-decoration-none small"><i class="fas fa-arrow-left"></i> Back to List</a>
            </div>
            <asp:HyperLink ID="lnkEdit" runat="server" CssClass="btn-edit-custom">
                <i class="fas fa-edit me-1"></i> Edit Details
            </asp:HyperLink>
        </div>

        <asp:Label ID="lblMsg" runat="server"></asp:Label>

        <div class="row" id="pnlDetails" runat="server">
            
            <div class="col-lg-8">
                
                <div class="detail-card">
                    <div class="main-cover-box mb-3">
                        <asp:Image ID="imgCover" runat="server" CssClass="main-cover-img" ImageUrl="~/Images/placeholder.png" />
                    </div>
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <h3 class="fw-bold text-dark mb-1"><asp:Label ID="lblName" runat="server"></asp:Label></h3>
                            <p class="text-muted mb-0"><i class="fas fa-map-marker-alt text-danger me-1"></i> <asp:Label ID="lblCityArea" runat="server"></asp:Label></p>
                        </div>
                        <div class="text-end">
                            <span class="badge bg-secondary p-2"><asp:Label ID="lblCategory" runat="server"></asp:Label></span>
                        </div>
                    </div>
                </div>

                <div class="detail-card">
                    <h6 class="card-heading">About & Amenities</h6>
                    
                    <p class="text-secondary mb-4" style="line-height: 1.6;">
                        <asp:Label ID="lblDesc" runat="server" Text="No description added."></asp:Label>
                    </p>

                    <div>
                        <strong class="d-block mb-2 text-dark">Facilities:</strong>
                        <asp:Repeater ID="rptFacilities" runat="server">
                            <ItemTemplate>
                                <span class="facility-pill"><i class="fas fa-check text-success me-1"></i> <%# Container.DataItem %></span>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Label ID="lblNoFacilities" runat="server" Visible="false" Text="No facilities listed." CssClass="text-muted small"></asp:Label>
                    </div>
                </div>

                <div class="detail-card">
                    <h6 class="card-heading">Location Map</h6>
                    <div class="map-container bg-light">
                        <asp:Literal ID="litMap" runat="server"></asp:Literal>
                    </div>
                    <div class="mt-3">
                        <small class="text-muted fw-bold">Full Address:</small>
                        <p class="text-dark m-0"><asp:Label ID="lblAddress" runat="server"></asp:Label></p>
                        <small class="text-muted">Landmark: <asp:Label ID="lblLandmark" runat="server"></asp:Label></small>
                    </div>
                </div>

            </div>

            <div class="col-lg-4">
                
                <div class="detail-card">
                    <h6 class="card-heading">Quick Info</h6>
                    <div class="mb-3 text-center">
                        <asp:Label ID="lblStatusBadge" runat="server"></asp:Label>
                    </div>
                    <ul class="info-list">
                        <li>
                            <span class="info-label"><i class="fas fa-phone me-2"></i>Phone</span>
                            <span class="info-val"><asp:Label ID="lblPhone" runat="server"></asp:Label></span>
                        </li>
                        <li>
                            <span class="info-label"><i class="fas fa-clock me-2"></i>Timings</span>
                            <span class="info-val"><asp:Label ID="lblTiming" runat="server"></asp:Label></span>
                        </li>
                        <li>
                            <span class="info-label"><i class="fas fa-wallet me-2"></i>Cost (2 ppl)</span>
                            <span class="info-val text-success">₹<asp:Label ID="lblMinPrice" runat="server"></asp:Label> - ₹<asp:Label ID="lblMaxPrice" runat="server"></asp:Label></span>
                        </li>
                    </ul>
                </div>

                <div class="detail-card">
                    <h6 class="card-heading">Signature Dish</h6>
                    <div class="dish-box">
                        <asp:Image ID="imgDish" runat="server" CssClass="dish-thumb" />
                        <div>
                            <h6 class="mb-0 fw-bold"><asp:Label ID="lblDishName" runat="server"></asp:Label></h6>
                            <small class="text-warning"><i class="fas fa-star"></i> Recommended</small>
                        </div>
                    </div>
                </div>

                <div class="detail-card">
                    <h6 class="card-heading">Menu Card</h6>
                    <div class="menu-grid">
                        <asp:Repeater ID="rptMenu" runat="server">
                            <ItemTemplate>
                                <div class="menu-item">
                                    <a href='<%# ResolveUrl("~/Images/menu/" + Container.DataItem) %>' target="_blank">
                                        <img src='<%# ResolveUrl("~/Images/menu/" + Container.DataItem) %>' alt="Menu" />
                                    </a>
                                </div>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="lblNoMenu" runat="server" Visible='<%# rptMenu.Items.Count == 0 %>' Text="No menu available." CssClass="text-muted small col-12"></asp:Label>
                            </FooterTemplate>
                        </asp:Repeater>
                    </div>
                </div>

            </div>

        </div>
    </div>

</asp:Content>