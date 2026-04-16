<%@ Page Title="Restaurant Details" Language="C#" MasterPageFile="~/admin/AdminMaster.master" AutoEventWireup="true" CodeFile="RestaurantDetails.aspx.cs" Inherits="admin_RestaurantDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        /* --- PROFILE CARD (Left) --- */
        .profile-card {
            background: #fff; border-radius: 12px; padding: 25px; text-align: center;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05); height: 100%;
        }
        
        .rest-logo-box {
            width: 120px; height: 120px; margin: 0 auto 15px; border-radius: 50%; overflow: hidden;
            border: 4px solid #fff; box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .rest-logo-box img { width: 100%; height: 100%; object-fit: cover; }

        .status-pill {
            padding: 5px 15px; border-radius: 20px; font-size: 12px; font-weight: 700; text-transform: uppercase; display: inline-block; margin-bottom: 10px;
        }
        .st-pending { background: #fff3cd; color: #856404; }
        .st-active { background: #d1fae5; color: #065f46; }
        .st-rejected { background: #fee2e2; color: #991b1b; }

        /* --- TABS --- */
        .nav-tabs .nav-link {
            color: #555; font-weight: 600; border: none; padding: 12px 20px;
        }
        .nav-tabs .nav-link.active {
            color: #1e3c72; border-bottom: 3px solid #1e3c72; background: none;
        }
        .tab-content {
            background: #fff; padding: 25px; border-radius: 0 0 12px 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05); min-height: 400px;
        }

        /* --- TAB CONTENT STYLES --- */
        .info-label { font-size: 12px; text-transform: uppercase; color: #888; font-weight: 600; display: block; margin-bottom: 3px; }
        .info-val { font-size: 15px; color: #333; font-weight: 500; }
        
        .menu-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(100px, 1fr)); gap: 15px; }
        .menu-item img { width: 100%; height: 100px; object-fit: cover; border-radius: 8px; border: 1px solid #eee; transition: 0.3s; cursor: pointer; }
        .menu-item img:hover { transform: scale(1.05); }

        .facility-tag { background: #f0f2f5; color: #555; padding: 6px 12px; border-radius: 6px; font-size: 13px; margin: 0 5px 5px 0; display: inline-block; }

        /* Map Container */
        .map-box { width: 100%; height: 250px; border-radius: 8px; overflow: hidden; background: #eee; }
        .map-box iframe { width: 100%; height: 100%; border: 0; }

    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div class="container-fluid">
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <a href="AllRestaurants.aspx" class="text-decoration-none text-muted small"><i class="fas fa-arrow-left"></i> Back to List</a>
                <h4 class="fw-bold text-dark m-0 mt-1">Restaurant Details</h4>
            </div>
        </div>

        <asp:Label ID="lblMsg" runat="server"></asp:Label>

        <div class="row g-4">
            
            <div class="col-lg-4">
                <div class="profile-card">
                    
                    <div class="rest-logo-box">
                        <asp:Image ID="imgCover" runat="server" ImageUrl="~/Images/placeholder.png" />
                    </div>

                    <h5 class="fw-bold text-dark mb-1"><asp:Label ID="lblRestNameHeader" runat="server"></asp:Label></h5>
                    <p class="text-muted small"><i class="fas fa-map-marker-alt text-danger"></i> <asp:Label ID="lblCityHeader" runat="server"></asp:Label></p>
                    
                    <asp:Label ID="lblStatusBadge" runat="server" CssClass="status-pill"></asp:Label>

                    <hr class="my-4" />

                    <div class="text-start mb-4">
                        <div class="mb-3">
                            <span class="info-label">Owner Name</span>
                            <span class="info-val"><i class="fas fa-user-circle me-2 text-primary"></i> <asp:Label ID="lblOwnerName" runat="server"></asp:Label></span>
                        </div>
                        <div class="mb-3">
                            <span class="info-label">Contact Number</span>
                            <span class="info-val"><i class="fas fa-phone-alt me-2 text-success"></i> <asp:Label ID="lblPhone" runat="server"></asp:Label></span>
                        </div>
                        <div>
                            <span class="info-label">Category</span>
                            <span class="info-val"><i class="fas fa-utensils me-2 text-warning"></i> <asp:Label ID="lblCategory" runat="server"></asp:Label></span>
                        </div>
                    </div>

                    <div class="d-grid gap-2">
                        <asp:Button ID="btnApprove" runat="server" Text="Approve Restaurant" CssClass="btn btn-success" OnClick="btnApprove_Click" />
                        <asp:Button ID="btnReject" runat="server" Text="Reject Request" CssClass="btn btn-outline-danger" OnClick="btnReject_Click" OnClientClick="return confirm('Reject this restaurant?');" />
                    </div>

                </div>
            </div>

            <div class="col-lg-8">
                
                <ul class="nav nav-tabs" id="myTab" role="tablist">
                    <li class="nav-item">
                        <button class="nav-link active" id="overview-tab" data-bs-toggle="tab" data-bs-target="#overview" type="button">Overview</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" id="menu-tab" data-bs-toggle="tab" data-bs-target="#menu" type="button">Menu & Dishes</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" id="location-tab" data-bs-toggle="tab" data-bs-target="#location" type="button">Location</button>
                    </li>
                </ul>

                <div class="tab-content" id="myTabContent">
                    
                    <div class="tab-pane fade show active" id="overview">
                        <h6 class="fw-bold text-dark mb-3">About Restaurant</h6>
                        <p class="text-muted small">
                            <asp:Label ID="lblDescription" runat="server" Text="No description available."></asp:Label>
                        </p>

                        <div class="row mt-4">
                            <div class="col-md-6 mb-3">
                                <span class="info-label">Current Offer</span>
                                <span class="text-primary fw-bold"><asp:Label ID="lblOffer" runat="server"></asp:Label></span>
                            </div>
                            <div class="col-md-6 mb-3">
                                <span class="info-label">Cost for Two</span>
                                <span class="text-success fw-bold">₹<asp:Label ID="lblPrice" runat="server"></asp:Label></span>
                            </div>
                            <div class="col-md-6 mb-3">
                                <span class="info-label">Opening Hours</span>
                                <span class="info-val"><asp:Label ID="lblTime" runat="server"></asp:Label></span>
                            </div>
                            <div class="col-md-6 mb-3">
                                <span class="info-label">Area / Locality</span>
                                <span class="info-val"><asp:Label ID="lblArea" runat="server"></asp:Label></span>
                            </div>
                        </div>

                        <div class="mt-3">
                            <h6 class="fw-bold text-dark mb-2">Facilities</h6>
                            <asp:Repeater ID="rptFacilities" runat="server">
                                <ItemTemplate>
                                    <span class="facility-tag"><i class="fas fa-check text-success me-1"></i> <%# Container.DataItem %></span>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="menu">
                        <div class="d-flex align-items-center mb-4 p-3 bg-light rounded">
                            <asp:Image ID="imgSignatureDish" runat="server" CssClass="rounded-circle me-3" Width="60" Height="60" ImageUrl="~/Images/food_placeholder.png" />
                            <div>
                                <small class="text-warning fw-bold text-uppercase">Signature Dish</small>
                                <h6 class="m-0 fw-bold"><asp:Label ID="lblSignatureDish" runat="server"></asp:Label></h6>
                            </div>
                        </div>

                        <h6 class="fw-bold text-dark mb-3">Menu Card Images</h6>
                        <div class="menu-grid">
                            <asp:Repeater ID="rptMenu" runat="server">
                                <ItemTemplate>
                                    <div class="menu-item">
                                        <a href='<%# ResolveUrl("~/Images/menu/" + Container.DataItem) %>' target="_blank">
                                            <img src='<%# ResolveUrl("~/Images/menu/" + Container.DataItem) %>' />
                                        </a>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                            <asp:Label ID="lblNoMenu" runat="server" Visible="false" Text="No menu uploaded." CssClass="text-muted small col-12"></asp:Label>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="location">
                        <div class="mb-3">
                            <span class="info-label">Full Address</span>
                            <p class="text-dark m-0"><asp:Label ID="lblAddress" runat="server"></asp:Label></p>
                        </div>
                        <div class="mb-4">
                            <span class="info-label">Nearby Landmark</span>
                            <p class="text-dark m-0"><asp:Label ID="lblLandmark" runat="server"></asp:Label></p>
                        </div>

                        <div class="map-box">
                            <asp:Literal ID="litMap" runat="server"></asp:Literal>
                        </div>
                    </div>

                </div>

            </div>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</asp:Content>