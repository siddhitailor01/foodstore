<%@ Page Title="Food Menu & Categories – Explore Best Dishes Near You | FoodStore" Language="C#" MasterPageFile="~/UserMaster.master" AutoEventWireup="true" CodeFile="menu.aspx.cs" Inherits="menu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    
    <meta name="description" content="Browse the full food menu at FoodStore. Explore categories like Pizza, Burger, Indian Thali, Biryani & more from top restaurants near you. View prices and order online." />

    <meta name="keywords" content="restaurant menu, food menu price list, online food order menu, food categories, best dishes near me, foodstore menu, fast food menu, dinner menu" />

    <meta name="robots" content="index, follow" />

    <link rel="canonical" href="https://www.foodstore.in/menu.aspx" />

    <meta property="og:title" content="Explore Food Menu & Categories – FoodStore" />
    <meta property="og:description" content="Hungry? Browse our delicious menu categories and find the best food near you." />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://www.foodstore.in/menu.aspx" />
    <meta property="og:image" content="https://www.foodstore.in/assets/images/og-menu.jpg" />

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "CollectionPage",
      "name": "FoodStore Menu",
      "description": "Browse food categories and restaurant menus with prices.",
      "url": "https://www.foodstore.in/menu.aspx",
      "breadcrumb": "Home > Menu",
      "mainEntity": {
        "@type": "ItemList",
        "itemListElement": [
          { "@type": "ListItem", "position": 1, "name": "Pizza" },
          { "@type": "ListItem", "position": 2, "name": "Burger" },
          { "@type": "ListItem", "position": 3, "name": "Indian Thali" },
          { "@type": "ListItem", "position": 4, "name": "Street Food" }
        ]
      }
    }
    </script>

    <style>
        /* Sidebar Styling */
        .sidebar-card { position: sticky; top: 100px; z-index: 10; border: 1px solid #eee; border-radius: 8px; }
        .cat-link { display: block; padding: 12px 20px; color: #555; text-decoration: none; border-bottom: 1px solid #f8f9fa; transition: 0.3s; }
        .cat-link:hover { background-color: #f8f9fa; color: #dc3545; padding-left: 25px; }
        .cat-link.active { background-color: #dc3545; color: white; border-color: #dc3545; }
        .cat-link i { margin-right: 10px; }
        
        /* Your Existing Styles Preserved */
        .dish-img { height:200px; width:100%; object-fit:cover; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <section class="bg-half-170 d-table w-100" style="background: url('assets/images/bg/pages.jpg') center center;">
        <div class="bg-overlay opacity-8"></div>
        <div class="container">
            <div class="row mt-5 justify-content-center">
                <div class="col-12">
                    <div class="title-heading text-center">
                        <h3 class="heading sub-heading fw-semibold mb-0 sub-heading text-white title-dark">Restaurant Menu</h3>
                    </div>
                </div>
            </div>
            <div class="position-middle-bottom">
                <nav aria-label="breadcrumb" class="d-block">
                    <ul class="breadcrumb breadcrumb-muted mb-0 p-0">
                        <li class="breadcrumb-item"><a href="index.aspx">FoodStore</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Menu</li>
                    </ul>
                </nav>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <div class="row">
                
                <div class="col-lg-3 col-md-4 col-12 mb-4 mb-md-0">
                    <div class="card bg-white shadow rounded-md border-0 sidebar-card">
                        <div class="card-header bg-white border-bottom">
                            <h5 class="mb-0">Categories</h5>
                        </div>
                        <div class="card-body p-0">
                            <a href="menu.aspx" class='cat-link <%= Request.QueryString["cat"] == null ? "active" : "" %>'>
                                <i class="ri-apps-line"></i> All Items
                            </a>

                            <asp:Repeater ID="rptCategories" runat="server">
                                <ItemTemplate>
                                    <a href='menu.aspx?cat=<%# Eval("CategoryID") %>' class='cat-link <%# IsActiveCategory(Eval("CategoryID")) %>'>
                                        <i class="ri-arrow-right-s-line"></i> <%# Eval("CategoryName") %>
                                    </a>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>

                <div class="col-lg-9 col-md-8 col-12">
                    
                    <div class="row row-cols-lg-3 row-cols-md-2 row-cols-1 g-4"> 
                        <asp:ListView ID="lvMenu" runat="server">
                            <ItemTemplate>
                                <div class="col">
                                    <div class="restaurant-card position-relative overflow-hidden bg-white shadow rounded-md">
                                        
                                        <img src='<%# GetImageUrl(Eval("SignatureDishImage")) %>' class="img-fluid rounded-md dish-img" alt="Order <%# Eval("SignatureDish") %> online">

                                        <div class="p-3">
                                            <span class="badge bg-soft-primary rounded-pill d-inline-flex align-items-center text-8px">
                                                <i class="ri-restaurant-2-line me-1"></i> <%# Eval("CategoryName") %>
                                            </span>

                                            <div class="mt-2">
                                                <a href='RestaurantDetails.aspx?id=<%# Eval("RestaurantID") %>' class="text-dark dish-name">
                                                    <%# Eval("SignatureDish") %>
                                                </a>
                                                <p class="text-muted mb-0 text-xs">by <%# Eval("RestaurantName") %></p>
                                            </div>

                                            <div class="d-flex justify-content-between align-items-center mt-2">
                                                <div>
                                                    <p class="text-sm mb-0">₹<%# Eval("MinPrice") %></p>
                                                </div>
                                                <a href='RestaurantDetails.aspx?id=<%# Eval("RestaurantID") %>' class="btn btn-sm btn-soft-primary">VIEW</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                            <EmptyDataTemplate>
                                <div class="col-12 text-center py-5">
                                    <div class="alert alert-light">
                                        <h4>No dishes found in this category.</h4>
                                        <a href="menu.aspx" class="btn btn-primary mt-2">View All</a>
                                    </div>
                                </div>
                            </EmptyDataTemplate>
                        </asp:ListView>

                    </div>

                    <div class="row">
                        <div class="col-12 mt-4">
                            <ul class="pagination mb-0 justify-content-center">
                                
                                <li class="page-item" id="liPrev" runat="server">
                                    <asp:HyperLink ID="lnkPrev" runat="server" class="page-link rounded-pill mx-1" aria-label="Previous">
                                        <span aria-hidden="true"><i class="ri-arrow-left-fill"></i></span>
                                    </asp:HyperLink>
                                </li>

                                <asp:Repeater ID="rptPaging" runat="server" OnItemDataBound="rptPaging_ItemDataBound">
                                    <ItemTemplate>
                                        <li class="page-item" id="liPage" runat="server">
                                            <asp:HyperLink ID="lnkPage" runat="server" class="page-link rounded-pill mx-1" 
                                                NavigateUrl='<%# GetPageUrl(Eval("PageIndex")) %>'>
                                                <%# Eval("PageText") %>
                                            </asp:HyperLink>
                                        </li>
                                    </ItemTemplate>
                                </asp:Repeater>

                                <li class="page-item" id="liNext" runat="server">
                                    <asp:HyperLink ID="lnkNext" runat="server" class="page-link rounded-pill mx-1" aria-label="Next">
                                        <span aria-hidden="true"><i class="ri-arrow-right-fill"></i></span>
                                    </asp:HyperLink>
                                </li>

                            </ul>
                        </div>
                    </div>

                </div></div></div></section>

</asp:Content>