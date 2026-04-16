<%@ Page Title="" Language="C#" MasterPageFile="~/UserMaster.master" AutoEventWireup="true" CodeFile="restaurantdetails.aspx.cs" Inherits="restaurantdetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .fac-badge { font-size: 0.9rem; margin-right: 8px; margin-bottom: 8px; padding: 8px 12px; border-radius: 20px; background-color: #f8f9fa; border: 1px solid #dee2e6; display: inline-block; color: #333; }
        .fac-badge i { color: #2eca8b; margin-right: 5px; }
        
        /* --- MENU SLIDER STYLE --- */
        .menu-scroll-container {
            display: flex;
            overflow-x: auto;
            gap: 15px;
            padding-bottom: 10px;
            scrollbar-width: thin; 
        }
        .menu-scroll-container::-webkit-scrollbar { height: 6px; }
        .menu-scroll-container::-webkit-scrollbar-thumb { background-color: #ccc; border-radius: 10px; }
        
      /* NEW (scoped) */
.menu-scroll-container .menu-item {
    flex: 0 0 auto;
    width: 200px;
}
        .menu-thumb {
            width: 100%;
            height: 280px; /* Increased Height */
            object-fit: cover;
            border-radius: 8px;
            cursor: pointer;
            transition: transform 0.3s;
            border: 1px solid #eee;
        }
        .menu-thumb:hover { transform: scale(1.03); box-shadow: 0 5px 15px rgba(0,0,0,0.2); }

        /* Modal Image */
        #modalImage { width: auto; max-width: 100%; max-height: 100vh; object-fit: contain; border-radius: 5px; display: block; margin: 0 auto; }

        @media (max-width: 766px) {
    .map,
    .map iframe {
        width: 100% !important;
        max-width: 100% !important;
    }

    .map iframe {
        height: 260px; /* optional – mobile friendly height */
    }
}



    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <asp:ListView ID="lvRestaurantDetail" runat="server" OnItemDataBound="lvRestaurantDetail_ItemDataBound" OnItemCommand="lvRestaurantDetail_ItemCommand">
        <ItemTemplate>
            
            <section class="section pb-0 mt-4 mt-lg-0">
                <div class="container">
                    <div class="py-5 rounded-md shadow-md" style='background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)), url("<%# GetImageUrl(Eval("CoverImage"), "Images/cover/") %>") center; background-size: cover;'>
                        <div class="row">
                            <div class="col-12">
                                <div class="m-4 p-4 bg-white rounded-md d-inline-block">
                                    <div class="mb-2">
                                        <span class="text-warning">
                                            <%# GenerateStars(Convert.ToInt32(Eval("AvgRating"))) %>
                                        </span>
                                        <span class="fw-bold ms-1 text-dark"><%# Eval("AvgRating", "{0:0.0}") %></span>
                                        <span class="text-muted small ms-1">(<%# Eval("ReviewCount") %> Reviews)</span>
                                    </div>

                                    <h4 class="mb-1"><%# Eval("Name") %></h4>
                                    
                                    <span class="text-muted d-inline-flex align-items-center">
                                        <i class="ri-circle-fill text-dark text-8px me-1"></i> <%# Eval("CategoryName") %>
                                        <asp:PlaceHolder ID="phDetailOffer" runat="server" Visible='<%# !string.IsNullOrEmpty(Eval("OfferText").ToString()) %>'>
                                            <span class="badge rounded-pill bg-danger text-white px-3 py-1 ms-2 align-middle">
                                                <i class="ri-price-tag-3-fill align-middle me-1"></i> <%# Eval("OfferText") %>
                                            </span>
                                        </asp:PlaceHolder>
                                    </span>

                                    <p class="mb-0 mt-2">
                                        <i class="ri-map-pin-line"></i> <%# Eval("Address") %>, <%# Eval("AreaName") %>
                                    </p>
                              <div class="mt-3 d-flex gap-2 align-items-center">
    
    
   

    <asp:LinkButton ID="btnCall" runat="server" OnClick="btnCall_Click" 
        CssClass="btn btn-outline-primary btn-sm rounded-pill px-3 fw-bold">
        <i class="ri-phone-fill me-1"></i> Call Now
    </asp:LinkButton>

    
    <a href="#" class="btn btn-outline-danger btn-sm rounded-pill px-3 fw-bold" data-bs-toggle="modal" data-bs-target="#reportModal">
        <i class="ri-flag-fill"></i> Report
    </a>

</div>
                                         
      
        
     
</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section class="section pt-5">
                <div class="container">
                    
                    <div class="row mb-4">
                        <div class="col-md-8">
                            <h5 class="mb-3">About Restaurant:</h5>
                            <p class="text-muted"><%# Eval("Description") %></p>
                        </div>
                        <div class="col-md-4">
                            <div class="p-3 bg-light rounded shadow-sm text-center">
                                <h6 class="text-danger fw-bold">Signature Dish</h6>
                                <img src='<%# GetImageUrl(Eval("SignatureDishImage"), "Images/dish/") %>' class="rounded-circle mb-2" style="width:100px; height:100px; object-fit:cover; border:3px solid white; box-shadow:0 2px 5px rgba(0,0,0,0.1);" />
                                <h5 class="mb-0"><%# Eval("SignatureDish") %></h5>
                                <p class="text-muted small mb-2">Must Try!</p>
                                <span class="badge bg-success fs-6">Price: ₹<%# Eval("MinPrice") %> - ₹<%# Eval("MaxPrice") %></span>
                            </div>
                        </div>
                    </div>

                    <asp:PlaceHolder ID="phMenu" runat="server">
                        <div class="row mt-4">
                            <div class="col-12">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h5 class="mb-0">Menu:</h5>
                                    <small class="text-muted">Swipe for more <i class="ri-arrow-right-line"></i></small>
                                </div>
                                
                                <div class="menu-scroll-container">
                                    <asp:Repeater ID="rptMenu" runat="server">
                                        <ItemTemplate>
                                            <div class="menu-item">
                                                <img src='<%# ResolveUrl("~/Images/menu/" + Container.DataItem) %>' 
                                                     class="menu-thumb shadow-sm" 
                                                     alt="Menu Page"
                                                     onclick="openImageModal(this.src)" />
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                    </asp:PlaceHolder>

                    <asp:PlaceHolder ID="phMap" runat="server">
                        <div class="row mt-4">
                            <div class="col-12">
                                <h5 class="mb-3">Location:</h5>
                                <div class="card map border-0">
                                    <div class="card-body p-0">
                                        <asp:Literal ID="litMap" runat="server"></asp:Literal>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </asp:PlaceHolder>

                    <div class="row mt-4">
                        <div class="col-12">
                            <h5 class="mb-3">Timings:</h5>
                            <p class="mb-0 text-muted"><i class="ri-calendar-line text-dark me-1"></i> Monday - Sunday</p>
                            <p class="mb-0 text-muted">
                                <i class="ri-time-line text-dark me-1"></i> <%# Eval("OpenTime") %> - <%# Eval("CloseTime") %>
                            </p>
                        </div>
                    </div>

                    <asp:PlaceHolder ID="phFacilities" runat="server">
                        <div class="row mt-4">
                            <div class="col-12">
                                <h5 class="mb-3">Facilities:</h5>
                                <div>
                                    <asp:Repeater ID="rptFacilities" runat="server">
                                        <ItemTemplate>
                                            <span class="fac-badge">
                                                <i class="ri-checkbox-circle-line align-middle"></i> <%# Container.DataItem %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                    </asp:PlaceHolder>

                    <div class="row mt-5">
                        <div class="col-12 d-flex justify-content-between align-items-center border-bottom pb-2 mb-4">
                            <h5 class="mb-0">Reviews & Ratings</h5>
                            <button type="button" class="btn btn-outline-primary btn-sm rounded-pill" data-bs-toggle="modal" data-bs-target="#reviewModal">
                                <i class="ri-pencil-line me-1"></i> Write a Review
                            </button>
                        </div>

                        <div class="col-12">
                            <asp:Repeater ID="rptReviews" runat="server">
                                <ItemTemplate>
                                    <div class="d-flex mb-4 border-bottom pb-3">
                                        <div class="me-3">
                                            <div class="avatar avatar-md rounded-circle bg-light text-primary text-center pt-2 fw-bold">
                                                <%# Eval("UserName").ToString().Substring(0,1) %>
                                            </div>
                                        </div>
                                        <div>
                                            <h6 class="mb-0"><%# Eval("UserName") %></h6>
                                            <div class="text-warning small">
                                                <%# GenerateStars(Convert.ToInt32(Eval("Rating"))) %>
                                                <span class="text-muted ms-2"><%# Eval("ReviewDate", "{0:dd MMM yyyy}") %></span>
                                            </div>
                                            <p class="text-muted mt-1 fst-italic">"<%# Eval("ReviewText") %>"</p>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                            <asp:Label ID="lblNoReviews" runat="server" Text="No reviews yet. Be the first to review!" CssClass="text-muted mt-2 d-block" Visible="false"></asp:Label>
                        </div>
                    </div>

                    <div class="modal fade" id="reviewModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Rate your experience</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <asp:Panel ID="pnlReviewForm" runat="server">
                                        <div class="mb-3">
                                            <label class="form-label small">Your Name</label>
                                            <asp:TextBox ID="txtReviewName" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label small">Rating</label>
                                            <asp:DropDownList ID="ddlRating" runat="server" CssClass="form-select">
                                                <asp:ListItem Value="5">⭐⭐⭐⭐⭐ Excellent</asp:ListItem>
                                                <asp:ListItem Value="4">⭐⭐⭐⭐ Good</asp:ListItem>
                                                <asp:ListItem Value="3">⭐⭐⭐ Average</asp:ListItem>
                                                <asp:ListItem Value="2">⭐⭐ Poor</asp:ListItem>
                                                <asp:ListItem Value="1">⭐ Bad</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label small">Review</label>
                                            <asp:TextBox ID="txtReviewMsg" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control"></asp:TextBox>
                                        </div>
                                        <asp:Label ID="lblReviewMsg" runat="server" EnableViewState="false"></asp:Label>
                                    </asp:Panel>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-light btn-sm" data-bs-dismiss="modal">Cancel</button>
                                    <asp:Button ID="btnSubmitReview" runat="server" Text="Submit Review" 
                                        CommandName="SubmitReview" CssClass="btn btn-primary btn-sm px-4" />
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </section>

        </ItemTemplate>
        <EmptyDataTemplate>
            <div class="container mt-5 text-center">
                <div class="alert alert-danger"><h4>Restaurant Not Found!</h4></div>
            </div>
        </EmptyDataTemplate>
    </asp:ListView>

    <div class="modal fade" id="imageViewerModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content bg-transparent border-0">
                <div class="modal-header border-0">
                    <button type="button" class="btn-close btn-close-white ms-auto" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center">
                    <img id="modalImage" src="" alt="Full Menu" class="img-fluid rounded shadow-lg" />
                </div>
            </div>
        </div>
    </div>

    <script>
        function openImageModal(imageSrc) {
            var modalImg = document.getElementById('modalImage');
            modalImg.src = imageSrc;
            var myModal = new bootstrap.Modal(document.getElementById('imageViewerModal'));
            myModal.show();
        }
    </script>

    <div class="modal fade" id="reportModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-light">
                <h6 class="modal-title text-danger"><i class="ri-alarm-warning-fill"></i> Report an Issue</h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p class="small text-muted mb-3">Help us keep FoodStore reliable. Why are you reporting this?</p>
                
                <div class="mb-3">
                    <label class="form-label small fw-bold">Reason</label>
                    <asp:DropDownList ID="ddlReportReason" runat="server" CssClass="form-select form-select-sm">
                        <asp:ListItem Value="Phone Switched Off">Phone Switched Off / Not Working</asp:ListItem>
                        <asp:ListItem Value="Seller Not Replying">Seller Not Replying</asp:ListItem>
                        <asp:ListItem Value="Shop Closed">Shop Closed / Not Found</asp:ListItem>
                        <asp:ListItem Value="Rude Behavior">Rude Behavior</asp:ListItem>
                        <asp:ListItem Value="Fake Listing">Fake Listing</asp:ListItem>
                        <asp:ListItem Value="Wrong Price/Menu">Wrong Price / Menu Info</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-bold">Additional Details</label>
                    <asp:TextBox ID="txtReportMsg" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control form-control-sm" placeholder="Tell us more about what happened..."></asp:TextBox>
                </div>

                <div class="d-grid">
                    <asp:Button ID="btnSubmitReport" runat="server" Text="Submit Report" OnClick="btnSubmitReport_Click" CssClass="btn btn-danger btn-sm" />
                </div>
            </div>
        </div>
    </div>
</div>

    <div class="modal fade" id="safetyModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content text-center">
            <div class="modal-header border-0 pb-0 justify-content-end">
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body pt-0">
                <div class="mb-3"><i class="ri-shield-check-fill text-success" style="font-size: 3rem;"></i></div>
                <h6 class="fw-bold">Safety Check</h6>
                <p class="text-muted small mb-4">Please wait for the seller's confirmation on WhatsApp or Call before visiting or making any payment.</p>
                <div class="d-grid gap-2">
                    <a id="btnProceedToWhatsApp" href="#" target="_blank" class="btn btn-success fw-bold">Continue to WhatsApp <i class="ri-arrow-right-line"></i></a>
                    <button type="button" class="btn btn-light btn-sm" data-bs-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
</div>

 

</asp:Content>