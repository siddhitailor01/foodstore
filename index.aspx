<%@ Page Title="" Language="C#" MasterPageFile="~/UserMaster.master" AutoEventWireup="true" CodeFile="index.aspx.cs" Inherits="index" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

    <title>FoodStore – Best Restaurants, Cafes & Street Food Near You</title>

    <meta name="description" content="Discover top-rated restaurants, cafes, street food & local food stores near you. View menus, reviews, photos, ratings and offers on FoodStore India." />

    <meta name="keywords" content="restaurants near me, cafes near me, street food near me, best restaurants in my city, food stores near me, restaurant menu online, top rated restaurants, foodstore india, restaurants in rajasthan, ajmer restaurants, bhilwara restaurants, order food online" />

    <link rel="canonical" href="https://www.foodstore.in/" />

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebSite",
      "name": "FoodStore",
      "url": "https://www.foodstore.in/",
      "potentialAction": {
        "@type": "SearchAction",
        "target": "https://www.foodstore.in/Restaurants.aspx?q={search_term_string}",
        "query-input": "required name=search_term_string"
      }
    }
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <section class="bg-half-170 bg-primary">
        <div class="bg-overlay" style="background: url('assets/images/bg/bg1.png') bottom no-repeat;"></div>
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-12">
                    <div class="title-heading text-center">
                      <h1 class="heading display-4 mb-4 fw-bold text-white title-dark">
                        Discover local food stores and restaurants
                      </h1>
                      <p class="para-desc text-white title-dark opacity-75 mx-auto mb-0">
                        Find street food, cafés, and restaurants in your city with complete location and store details.
                      </p>

                    <%--    <div class="subcribe-form mt-4">
                            <form class="mx-auto">
                                <input type="text" id="searchtext" name="text" class="border rounded-pill ps-4" placeholder="Search for restaurant, item or more">
                                <button type="submit" class="btn btn-primary rounded-pill">Search <i class="ri-arrow-right-fill"></i></button>
                            </form>
                        </div>--%>
                    </div>
                </div>
            </div>

            <div class="row justify-items-center pt-4">
                <div class="col-md-12">
                    <div class="tiny-six-item-arrow">
                        
                      <asp:Repeater ID="rptCategories" runat="server">
    <ItemTemplate>
        <div class="tiny-slide">
            <a href='<%# GetCategoryUrl(Eval("CategoryID")) %>' class="text-decoration-none">
                
                <div class="food-categories p-3 bg-white rounded text-center m-2 shadow-sm d-flex flex-column justify-content-center align-items-center h-100" 
                     style="min-height: 180px; transition: transform 0.3s;">
                    
                    <img src='<%# GetImageUrl(Eval("CategoryImage"), "images/category/") %>' 
                         alt='<%# Eval("CategoryName") + " near me" %>'
                         class="rounded-pill img-fluid shadow-sm"
                         style="width:80px; height:80px; object-fit:cover; margin: 0 auto;">

                    <div class="mt-3">
                        <span class="fs-5 text-dark fw-bold categoty-name">
                            <%# Eval("CategoryName") %>
                        </span>
                    </div>
                </div>

            </a>
        </div>
    </ItemTemplate>
</asp:Repeater>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <section class="section">
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <div class="section-title mb-4 pb-2">
                        <h2 class="title fw-medium mb-2">Discover Best Restaurants</h2>
                        <p class="text-muted para-desc mb-0">Please select your favorite restaurant.</p>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                
                <asp:ListView ID="lvRestaurants" runat="server">
    <ItemTemplate>
        <div class="col-xl-3 col-lg-4 col-md-6 col-12 d-flex align-items-stretch"> <div class="restaurant-card card position-relative overflow-hidden shadow rounded-md w-100 h-100">

    <div class="card-img position-relative overflow-hidden rounded-0">
        <img src='<%# GetImageUrl(Eval("CoverImage"), "Images/cover/") %>' 
            alt='<%# Eval("Name") + " restaurant in " + Eval("AreaName") %>'
             class="img-fluid restaurant-img w-100" 
             style="height: 200px; object-fit: cover;">

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
    <EmptyDataTemplate>
        <div class="col-12 text-center">
            <p>No Approved Restaurants Found.</p>
        </div>
    </EmptyDataTemplate>
</asp:ListView>

            </div>

            <div class="row justify-content-center mt-4">
                <div class="col">
                    <div class="text-center">
                        <a href="Restaurants.aspx" class="text-primary">All Restaurants <i class="ri-arrow-right-line ms-1"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </section>
    </asp:Content>