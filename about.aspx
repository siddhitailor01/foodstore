<%@ Page Title="About FoodStore – Best Local Food Directory in Your City" Language="C#" MasterPageFile="~/UserMaster.master" AutoEventWireup="true" CodeFile="about.aspx.cs" Inherits="about" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">


    <meta name="description" content="Learn about FoodStore – a local food discovery platform to find restaurants, cafes, street food and food stores near you with locations, menus, reviews and ratings." />

    <meta name="keywords" content="about foodstore, foodstore india, restaurants near me, cafes near me, street food near me, local food directory, best restaurants in my city, foodstore rajasthan, ajmer restaurants, bhilwara restaurants" />

    <meta name="robots" content="index, follow" />

    <link rel="canonical" href="https://www.foodstore.in/about.aspx" />

    <meta property="og:title" content="About FoodStore – Discover Local Food Near You" />
    <meta property="og:description" content="FoodStore helps you discover restaurants, cafes and street food near you with menus, reviews, ratings and locations." />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://www.foodstore.in/about.aspx" />
    <meta property="og:image" content="https://www.foodstore.in/assets/images/og-foodstore.jpg" />

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "Organization",
      "name": "FoodStore",
      "url": "https://www.foodstore.in/",
      "logo": "https://www.foodstore.in/assets/images/logo.png",
      "description": "FoodStore is a local food discovery platform connecting users with the best restaurants, cafes, and street food vendors.",
      "foundingDate": "2026",
      "address": {
        "@type": "PostalAddress",
        "addressLocality": "Ajmer",
        "addressRegion": "Rajasthan",
        "addressCountry": "IN"
      },
      "contactPoint": {
        "@type": "ContactPoint",
        "email": "support@foodstore.in",
        "contactType": "customer support"
      }
    }
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

      <section class="bg-half-170 d-table w-100" style="background: url('assets/images/bg/pages.jpg') center center;">
        <div class="bg-overlay opacity-8"></div>
        <div class="container">
            <div class="row mt-5 justify-content-center">
                <div class="col-12">
                    <div class="title-heading text-center">
                        <h1 class="heading sub-heading fw-semibold mb-0 sub-heading text-white title-dark">About Us</h1>
                    </div>
                </div>
            </div>
            
            <div class="position-middle-bottom">
                <nav aria-label="breadcrumb" class="d-block">
                    <ul class="breadcrumb breadcrumb-muted mb-0 p-0">
                        <li class="breadcrumb-item"><a href="index.aspx">FoodStore</a></li>
                        <li class="breadcrumb-item active" aria-current="page">About Us</li>
                    </ul>
                </nav>
            </div>
        </div>
      </section>

    <section class="bg-light align-items-center d-flex" style="padding: 100px 0;">
        <div class="container">
            <div class="row align-items-center">
                
                <div class="col-lg-6 col-md-6">
                    <div class="position-relative">
                        <img src="assets/images/about.png" class="img-fluid rounded shadow-lg" alt="About FoodStore Team" style="width: 100%; object-fit: cover; border-radius: 15px;">
                    </div>
                </div>

                <div class="col-lg-6 col-md-6 mt-4 mt-sm-0 pt-2 pt-sm-0">
                    <div class="section-title ms-lg-5">
                        <h6 class="text-primary fw-bold mb-2">OUR STORY</h6>
                        <h2 class="title mb-4 fw-bold">About FoodStore</h2>
                        
                       <p class="text-muted para-desc">
    Welcome to <b>FoodStore</b>, your trusted platform to explore the best food destinations in your city. We help you discover local restaurants, cafés, street food spots, and popular eateries with complete details, locations, and specialties — all in one place.
</p>

<p class="text-muted para-desc mb-0">
    Launched in 2026, FoodStore was created with a simple vision: to connect food lovers with authentic local food stores and restaurants. Whether you're searching for a famous dish, a nearby café, or a new place to try, FoodStore makes food discovery easy, reliable, and enjoyable.
</p>

                    
                        <div class="mt-4 pt-2">
                            <a href="contact.aspx" class="btn btn-primary rounded-pill px-4 py-2">Contact Us</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>