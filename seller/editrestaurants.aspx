<%@ Page Title="Edit Restaurant" Language="C#" MasterPageFile="~/seller/SellerMaster.master" AutoEventWireup="true" CodeFile="editrestaurants.aspx.cs" Inherits="seller_editrestaurants" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        /* Same Tabbed Styling for Consistency */
        .form-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
            border: none;
            min-height: 500px;
        }
        
        .form-header {
            background: linear-gradient(45deg, #d32f2f, #ef5350); /* Blue Gradient for Edit */
            color: white;
            padding: 15px 25px;
            border-radius: 12px 12px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .nav-tabs { border-bottom: 2px solid #f1f1f1; margin-bottom: 20px; }
        .nav-link { color: #666; font-weight: 500; border: none; padding: 12px 20px; font-size: 14px; transition: 0.3s; }
        .nav-link:hover { color: #0284c7; background: #f0f9ff; }
        .nav-link.active { color: #0284c7; background: transparent; border-bottom: 3px solid #0284c7; font-weight: 700; }
        .nav-link i { margin-right: 8px; }

        .tab-content { padding: 0 10px 20px 10px; }

        .form-label { font-size: 13px; font-weight: 500; margin-bottom: 5px; color: #444; }
        .form-control, .form-select { height: 45px; border-radius: 8px; font-size: 14px; border: 1px solid #e0e0e0; }
        .form-control:focus { border-color: #0284c7; box-shadow: none; background: #fff; }

        .facilities-box {
            background: #fcfcfc; padding: 15px; border-radius: 8px; border: 1px solid #eee;
            max-height: 300px; overflow-y: auto;
        }
        .facility-list label { font-size: 13px; margin-left: 5px; margin-right: 15px; cursor: pointer; color: #555; }
        .facility-list input { accent-color: #0284c7; cursor: pointer; transform: scale(1.1); }

        .btn-update {
            background: #0284c7; color: white; padding: 12px; border-radius: 8px; border: none; font-weight: 600; width: 100%; margin-top: 20px;
        }
        .btn-update:hover { background: #0369a1; color: white; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(2,132,199,0.2); }

        /* Current Image Preview Styling */
        .preview-box {
            background: #f8f9fa; border: 1px dashed #ccc; padding: 10px; border-radius: 8px; margin-top: 10px; display: inline-block;
        }
        .current-img { width: 80px; height: 80px; object-fit: cover; border-radius: 6px; }
        .preview-label { display: block; font-size: 11px; color: #888; margin-bottom: 5px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div class="row justify-content-center">
        <div class="col-lg-10">
            
            <div class="form-card">
                
                <div class="form-header">
                    <h5 class="mb-0 fw-bold"><i class="fas fa-edit me-2"></i> Edit Restaurant</h5>
                    <a href="MyRestaurants.aspx" class="btn btn-sm  text-white fw-bold"><i class="fas fa-arrow-left me-1"></i> Back</a>
                </div>

                <div class="card-body">
                    <asp:Label ID="lblMsg" runat="server"></asp:Label>

                    <asp:HiddenField ID="hfCoverImage" runat="server" />
                    <asp:HiddenField ID="hfDishImage" runat="server" />
                    <asp:HiddenField ID="hfMenuImages" runat="server" />

                    <ul class="nav nav-tabs" id="editTab" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="basic-tab" data-bs-toggle="tab" data-bs-target="#basic" type="button" role="tab"><i class="fas fa-info-circle"></i> Basic Info</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="loc-tab" data-bs-toggle="tab" data-bs-target="#loc" type="button" role="tab"><i class="fas fa-map-marker-alt"></i> Location & Time</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="feat-tab" data-bs-toggle="tab" data-bs-target="#feat" type="button" role="tab"><i class="fas fa-concierge-bell"></i> Facilities</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="media-tab" data-bs-toggle="tab" data-bs-target="#media" type="button" role="tab"><i class="fas fa-camera"></i> Photos</button>
                        </li>
                    </ul>

                    <div class="tab-content" id="editTabContent">
                        
                        <div class="tab-pane fade show active" id="basic" role="tabpanel">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Restaurant Name</label>
                                    <asp:TextBox ID="txtName" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Contact Phone</label>
                                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Select City</label>
                                    <asp:DropDownList ID="ddlCity" runat="server" CssClass="form-select"></asp:DropDownList>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Category</label>
                                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select"></asp:DropDownList>
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Short Description</label>
                                    <asp:TextBox ID="txtDesc" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                                </div>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="loc" role="tabpanel">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Area / Colony</label>
                                    <asp:TextBox ID="txtArea" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Landmark</label>
                                    <asp:TextBox ID="txtLandmark" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Full Address</label>
                                    <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                </div>
                                
                                <div class="col-md-3">
                                    <label class="form-label">Open Time</label>
                                    <asp:TextBox ID="txtOpen" runat="server" CssClass="form-control" TextMode="Time"></asp:TextBox>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Close Time</label>
                                    <asp:TextBox ID="txtClose" runat="server" CssClass="form-control" TextMode="Time"></asp:TextBox>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Min Price (₹)</label>
                                    <asp:TextBox ID="txtMinPrice" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Max Price (₹)</label>
                                    <asp:TextBox ID="txtMaxPrice" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                                </div>
                                <div class="col-md-6">
    <label class="form-label">Latitude</label>
    <asp:TextBox ID="txtLat" runat="server" CssClass="form-control" placeholder="e.g. 26.9124"></asp:TextBox>
    <small class="text-muted" style="font-size:11px;">From Google Maps (Right click > First number)</small>
</div>
<div class="col-md-6">
    <label class="form-label">Longitude</label>
    <asp:TextBox ID="txtLng" runat="server" CssClass="form-control" placeholder="e.g. 75.7873"></asp:TextBox>
    <small class="text-muted" style="font-size:11px;">From Google Maps (Right click > Second number)</small>
</div>
                                <div class="col-12">
                                    <label class="form-label">Google Map Embed Link</label>
                                    <asp:TextBox ID="txtMap" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="feat" role="tabpanel">
                            <div class="row g-3">
                                <div class="col-12">
                                    <label class="form-label mb-2">Available Facilities</label>
                                    <div class="facilities-box">
                                       <asp:CheckBoxList ID="cblFacilities" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow" CssClass="d-flex flex-wrap gap-3">

                

                <asp:ListItem Value="AC">Air Conditioned</asp:ListItem>

                <asp:ListItem Value="WiFi">Free Wi-Fi</asp:ListItem>

                <asp:ListItem Value="PowerBackup">Power Backup</asp:ListItem>

                

                <asp:ListItem Value="Parking">Parking Available</asp:ListItem>

                <asp:ListItem Value="Valet">Valet Parking</asp:ListItem>

                <asp:ListItem Value="Wheelchair">Wheelchair Accessible</asp:ListItem>

                <asp:ListItem Value="Elevator">Elevator / Lift</asp:ListItem>



                <asp:ListItem Value="Veg">Pure Veg</asp:ListItem>

                <asp:ListItem Value="NonVeg">Non-Veg Available</asp:ListItem>

                <asp:ListItem Value="Halal">Halal Meat</asp:ListItem>

                <asp:ListItem Value="Bar">Bar / Alcohol Served</asp:ListItem>

                <asp:ListItem Value="Buffet">Buffet Service</asp:ListItem>

                <asp:ListItem Value="Breakfast">Breakfast Menu</asp:ListItem>



                <asp:ListItem Value="Card">Card Payment Accepted</asp:ListItem>

                <asp:ListItem Value="Wallet">Digital Wallets (UPI/Paytm)</asp:ListItem>

                <asp:ListItem Value="Delivery">Home Delivery</asp:ListItem>

                <asp:ListItem Value="Takeaway">Takeaway Available</asp:ListItem>

                <asp:ListItem Value="Catering">Outdoor Catering</asp:ListItem>



                <asp:ListItem Value="Rooftop">Rooftop Seating</asp:ListItem>

                <asp:ListItem Value="Outdoor">Outdoor / Garden Seating</asp:ListItem>

                <asp:ListItem Value="Private">Private Dining Area</asp:ListItem>

                <asp:ListItem Value="Smoking">Smoking Area</asp:ListItem>

                <asp:ListItem Value="Romantic">Romantic / Candle Light</asp:ListItem>



                <asp:ListItem Value="Music">Live Music</asp:ListItem>

                <asp:ListItem Value="DJ">DJ / Dance Floor</asp:ListItem>

                <asp:ListItem Value="Sports">Live Sports Screening</asp:ListItem>

                <asp:ListItem Value="Pets">Pet Friendly</asp:ListItem>

                <asp:ListItem Value="Kids">Kid Friendly</asp:ListItem>

                <asp:ListItem Value="Games">Board Games / Pool Table</asp:ListItem>



                <asp:ListItem Value="LateNight">Open Late Night</asp:ListItem>

                <asp:ListItem Value="24x7">Open 24/7</asp:ListItem>



            </asp:CheckBoxList>
                                    </div>
                                </div>
                                <div class="col-12 mt-3">
                                    <label class="form-label">Special Offer Text</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-warning border-0"><i class="fas fa-tag"></i></span>
                                        <asp:TextBox ID="txtOffer" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="media" role="tabpanel">
                            <div class="row g-4">
                                
                                <div class="col-md-6">
                                    <label class="form-label">Main Cover Photo</label>
                                    <asp:FileUpload ID="fuCoverImage" runat="server" CssClass="form-control" />
                                    <div class="preview-box">
                                        <span class="preview-label">Current Image:</span>
                                        <asp:Image ID="imgCoverPreview" runat="server" CssClass="current-img" ImageUrl="~/Images/placeholder.png" />
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Signature Dish Photo</label>
                                    <asp:FileUpload ID="fuSigImage" runat="server" CssClass="form-control" />
                                    <div class="preview-box">
                                        <span class="preview-label">Current Image:</span>
                                        <asp:Image ID="imgDishPreview" runat="server" CssClass="current-img" ImageUrl="~/Images/placeholder.png" />
                                    </div>
                                </div>

                                <div class="col-12">
                                    <label class="form-label">Signature Dish Name</label>
                                    <asp:TextBox ID="txtSigDish" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>

                                <div class="col-12">
                                    <label class="form-label">Menu Photos</label>
                                    <asp:FileUpload ID="fuMenu" runat="server" CssClass="form-control" AllowMultiple="true" />
                                    <small class="text-danger d-block mt-1">
                                        <i class="fas fa-exclamation-triangle"></i> Note: Uploading new files will replace existing menu images. Hold 'Ctrl' to select multiple.
                                    </small>
                                </div>
                            </div>

                            <hr class="mt-4" />
                            
                            <asp:Button ID="btnUpdate" runat="server" Text="Save Changes" CssClass="btn-update" OnClick="btnUpdate_Click" />
                        </div>

                    </div>
                    </div>
            </div>
        </div>
    </div>

</asp:Content>