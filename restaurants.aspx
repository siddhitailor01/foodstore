<%@ Page Title="Best Restaurants Near Me – Order Food Online | FoodStore" Language="C#" MasterPageFile="~/UserMaster.master" AutoEventWireup="true" CodeFile="restaurants.aspx.cs" Inherits="restaurants" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    
    <meta name="description" content="Find the best restaurants, cafes, and street food places near you on FoodStore. Filter by rating, price, and cuisine. Order food online or dine-in." />

    <meta name="keywords" content="restaurants near me, best restaurants, order food online, top rated cafes, street food directory, foodstore restaurants, dining places, food delivery" />

    <meta name="robots" content="index, follow" />

    <link rel="canonical" href="https://www.foodstore.in/restaurants.aspx" />

    <meta property="og:title" content="Best Restaurants & Cafes Near You – FoodStore" />
    <meta property="og:description" content="Discover top-rated places to eat. View menus, reviews, photos and order online." />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://www.foodstore.in/restaurants.aspx" />
    <meta property="og:image" content="https://www.foodstore.in/assets/images/og-restaurants.jpg" />

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "CollectionPage",
      "name": "Restaurants on FoodStore",
      "description": "List of top-rated restaurants, cafes and food spots.",
      "url": "https://www.foodstore.in/restaurants.aspx",
      "mainEntity": {
        "@type": "ItemList",
        "itemListElement": [
          { "@type": "ListItem", "position": 1, "name": "Top Rated Restaurants" },
          { "@type": "ListItem", "position": 2, "name": "Budget Friendly Cafes" },
          { "@type": "ListItem", "position": 3, "name": "Street Food Joints" }
        ]
      }
    }
    </script>

    <style>
        .rating-filter a:hover {
            color: #ff7a2f;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <section class="bg-half-170 d-table w-100" style="background: url('assets/images/bg/pages.jpg') center center;">
        <div class="bg-overlay opacity-8"></div>
        <div class="container">
            <div class="row mt-5 justify-content-center">
                <div class="col-12">
                    <div class="title-heading text-center">
                        <h1 class="heading sub-heading fw-semibold mb-0 sub-heading text-white title-dark">Restaurants</h1>
                    </div>
                </div>
            </div>
            <div class="position-middle-bottom">
                <nav aria-label="breadcrumb" class="d-block">
                    <ul class="breadcrumb breadcrumb-muted mb-0 p-0">
                        <li class="breadcrumb-item"><a href="index.aspx">FoodStore</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Restaurants</li>
                    </ul>
                </nav>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <div class="row">
                
                <div class="col-lg-3 col-md-4 col-12">
                    <div class="card border-0 sidebar sticky-bar">
                        <div class="card-body p-0">
                            <div class="widget">
                                <h5 class="widget-title">Categories</h5>
                                <div class="row mt-4">
                                    <div class="col-12">
                                        <ul class="list-unstyled mb-0 list-catagories">
                                            <li class="d-flex justify-content-between align-items-center mb-3">
                                                <a href="restaurants.aspx" class="text-dark">All Categories</a>
                                                <span class="badge rounded-pill bg-light text-dark border">
                                                    <asp:Label ID="lblTotalCount" runat="server"></asp:Label>
                                                </span>
                                            </li>

                                            <asp:Repeater ID="rptCategories" runat="server">
                                                <ItemTemplate>
                                                    <li class="d-flex justify-content-between align-items-center mb-3">
                                                        <a href='<%# GetCategoryLink(Eval("CategoryID")) %>' 
                                                           class='<%# IsActiveCategory(Eval("CategoryID")) ? "text-primary fw-bold" : "text-dark" %>'>
                                                            <%# Eval("CategoryName") %>
                                                        </a>
                                                        <span class="badge rounded-pill bg-light text-dark border">
                                                            <%# Eval("RestCount") %>
                                                        </span>
                                                    </li>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                 <div class="widget mt-4 pt-2">
    <h5 class="widget-title">Filter by Price</h5>

    <div class="mt-4">
        <div class="row g-2 mb-3">
            <div class="col-6">
                <label class="form-label text-muted small mb-1">Min Price</label>
                <asp:TextBox 
                    ID="txtMinPrice" 
                    runat="server" 
                    CssClass="form-control font-sm" 
                    placeholder="₹0" 
                    TextMode="Number">
                </asp:TextBox>
            </div>

            <div class="col-6">
                <label class="form-label text-muted small mb-1">Max Price</label>
                <asp:TextBox 
                    ID="txtMaxPrice" 
                    runat="server" 
                    CssClass="form-control font-sm" 
                    placeholder="₹2000" 
                    TextMode="Number">
                </asp:TextBox>
            </div>
        </div>

        <div class="d-grid">
            <asp:Button 
                ID="btnFilterPrice" 
                runat="server" 
                Text="Apply Filter" 
                CssClass="btn btn-primary btn-sm rounded-md"
                OnClick="btnFilterPrice_Click" />
        </div>

        <div class="text-center mt-2">
            <a href="<%= ClearPriceLink() %>" class="text-muted small">Reset Price</a>
        </div>
    </div>
</div>

<div class="widget mt-5 pt-2">
    <h5 class="widget-title">Filter by Rating</h5>

    <div class="mt-3">
        <ul class="list-unstyled mb-0 rating-filter">
            <li class="mb-2">
                <a href="<%= GetRatingLink(4) %>" class="text-dark d-flex align-items-center gap-2">
                    ⭐⭐⭐⭐ <span class="small">&amp; above</span>
                </a>
            </li>

            <li class="mb-2">
                <a href="<%= GetRatingLink(3) %>" class="text-dark d-flex align-items-center gap-2">
                    ⭐⭐⭐ <span class="small">&amp; above</span>
                </a>
            </li>

            <li class="mb-2">
                <a href="<%= GetRatingLink(2) %>" class="text-dark d-flex align-items-center gap-2">
                    ⭐⭐ <span class="small">&amp; above</span>
                </a>
            </li>

            <li class="mt-3">
                <a href="<%= ClearRatingLink() %>" class="text-muted small">Reset Rating</a>
            </li>
        </ul>
    </div>
</div>


                            </div>
                        </div>
                    </div><div class="col-lg-9 col-md-8 col-12 mt-4 mt-sm-0 pt-2 pt-sm-0">
                        
                        <div class="row mb-4">
                            <div class="col-12 d-flex justify-content-between align-items-center mb-3">
                                <h5 class="mb-0"><asp:Label ID="lblSearchResult" runat="server" Text="All Restaurants"></asp:Label></h5>
                             <select class="form-select form-select-sm w-auto"
            onchange="location.href=this.value">
        <option value="<%= GetSortLink("") %>">Sort by</option>
        <option value="<%= GetSortLink("rating") %>">Top Rated</option>
        <option value="<%= GetSortLink("nearby") %>">Nearest</option>
        <option value="<%= GetSortLink("price_low") %>">Price: Low to High</option>
        <option value="<%= GetSortLink("price_high") %>">Price: High to Low</option>
        <option value="<%= GetSortLink("newest") %>">Newest</option>
    </select>
  


                             </div>
                                                              <asp:Panel ID="pnlActiveFilters" runat="server" Visible="false" CssClass="mt-2">
    <asp:Repeater ID="rptActiveFilters" runat="server">
        <ItemTemplate>
            <a href="<%# Eval("Url") %>" class="badge rounded-pill bg-light text-dark border me-2 mb-2 px-3 py-2 text-decoration-none">
                <%# Eval("Text") %> <span class="ms-1">✕</span>
            </a>
        </ItemTemplate>
    </asp:Repeater>

    <a href="restaurants.aspx" class="badge rounded-pill bg-dark text-white me-2 mb-2 px-3 py-2 text-decoration-none">
        Clear All
    </a>
</asp:Panel>
                    </div>

                    <div class="row g-4">
                        <asp:Repeater ID="rptRestaurants" runat="server">
                            <ItemTemplate>
                                <div class="col-lg-4 col-md-6 col-12 d-flex align-items-stretch">
                                     <div class="restaurant-card card position-relative overflow-hidden shadow rounded-md w-100 h-100">

    <div class="card-img position-relative overflow-hidden rounded-0">
       <img src='<%# GetImageUrl(Eval("CoverImage"), "Images/cover/") %>' 
     class="img-fluid restaurant-img w-100" 
     style="height: 200px; object-fit: cover;" 
     alt='<%# Eval("Name") + " Restaurant in " + Eval("AreaName") %>'>


        <div class="card-overlay opacity-100"></div>

        <span class="position-absolute top-0 start-0 m-2 badge 
            <%# IsOpenNow(Eval("OpenTime"), Eval("CloseTime")) ? "bg-success" : "bg-secondary" %>">
            <%# IsOpenNow(Eval("OpenTime"), Eval("CloseTime")) ? "Open Now" : "Closed" %>
        </span>

        <div class="position-absolute bottom-0 start-0 ps-3 pb-3">
            <a href="RestaurantDetails.aspx?id=<%# Eval("RestaurantID") %>" 
               class="text-white restaurant-name fs-5">
                <%# Eval("Name") %>
            </a>
        </div>
    </div>

    <div class="p-3 d-flex flex-column flex-grow-1">

        <div class="d-flex justify-content-between">
            <span class="text-muted small">
                <i class="ri-circle-fill text-dark text-6px me-1"></i>
                <%# Eval("CategoryName") %>
            </span>
            <span class="text-muted small">
                ₹<%# Eval("MinPrice") %> - ₹<%# Eval("MaxPrice") %>
            </span>
        </div>

        <div class="d-flex justify-content-between align-items-center mt-2">
            <span class="text-sm">
                <i class="ri-map-pin-line"></i>
                <%# Eval("AreaName") %>
            </span>

            <span class="badge bg-light text-warning border">
    <i class="ri-star-fill me-1"></i>
    <%# Math.Round(Convert.ToDouble(Eval("AvgRating")), 1) %>
</span>

        </div>

        <div class="mt-auto pt-2">
            <asp:PlaceHolder ID="phOffer" runat="server"
                Visible='<%# !string.IsNullOrEmpty(Eval("OfferText").ToString()) %>'>
                <span class="text-danger text-xs fw-bold">
                    <i class="ri-discount-percent-fill"></i>
                    <%# Eval("OfferText") %>
                </span>
            </asp:PlaceHolder>

            <asp:PlaceHolder ID="phNoOffer" runat="server"
                Visible='<%# string.IsNullOrEmpty(Eval("OfferText").ToString()) %>'>
                <span class="text-xs">&nbsp;</span>
            </asp:PlaceHolder>
        </div>

    </div>
</div>

                                </div>
                            </ItemTemplate>
                        </asp:Repeater>

                        <asp:Panel ID="pnlNoData" runat="server" Visible="false" CssClass="col-12 text-center mt-5">
                            <div class="py-5">
                                <i class="ri-store-3-line display-1 text-muted"></i>
                                <h4 class="text-muted mt-3">No Restaurants Found</h4>
                                <p class="text-muted">Try removing filters.</p>
                                <a href="restaurants.aspx" class="btn btn-primary mt-3">Clear Filters</a>
                            </div>
                        </asp:Panel>
                    </div>

                    <div class="row">
                        <div class="col-12 mt-4">
                            <ul class="pagination mb-0 justify-content-center">
                                <li class="page-item" id="liPrev" runat="server">
                                    <asp:HyperLink ID="lnkPrev" runat="server" class="page-link rounded-pill mx-1"><i class="ri-arrow-left-fill"></i></asp:HyperLink>
                                </li>
                                <asp:Repeater ID="rptPaging" runat="server" OnItemDataBound="rptPaging_ItemDataBound">
                                    <ItemTemplate>
                                        <li class="page-item" id="liPage" runat="server">
                                            <asp:HyperLink ID="lnkPage" runat="server" class="page-link rounded-pill mx-1" NavigateUrl='<%# Eval("PageUrl") %>'><%# Eval("PageIndex") %></asp:HyperLink>
                                        </li>
                                    </ItemTemplate>
                                </asp:Repeater>
                                <li class="page-item" id="liNext" runat="server">
                                    <asp:HyperLink ID="lnkNext" runat="server" class="page-link rounded-pill mx-1"><i class="ri-arrow-right-fill"></i></asp:HyperLink>
                                </li>
                            </ul>
                        </div>
                    </div>

                </div></div></div></section>

</asp:Content>