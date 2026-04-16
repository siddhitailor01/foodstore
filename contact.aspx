<%@ Page Title="Contact FoodStore – Customer Support & Restaurant Partner Enquiries" Language="C#" MasterPageFile="~/UserMaster.master" AutoEventWireup="true" CodeFile="contact.aspx.cs" Inherits="contact" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    
    <meta name="description" content="Get in touch with FoodStore for customer support, feedback, or restaurant partnership enquiries. We are here to help you find the best food in Bhilwara & Rajasthan." />

    <meta name="keywords" content="contact foodstore, foodstore customer care, foodstore support email, restaurant partner enquiry, foodstore bhilwara contact, customer support india" />

    <meta name="robots" content="index, follow" />

    <link rel="canonical" href="https://www.foodstore.in/contact.aspx" />

    <meta property="og:title" content="Contact FoodStore – We are here to help" />
    <meta property="og:description" content="Have a query or want to become a partner? Contact FoodStore support team today." />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://www.foodstore.in/contact.aspx" />
    <meta property="og:image" content="https://www.foodstore.in/assets/images/og-contact.jpg" />

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "ContactPage",
      "name": "Contact FoodStore",
      "description": "Contact page for FoodStore customer support and business enquiries.",
      "url": "https://www.foodstore.in/contact.aspx",
      "mainEntity": {
        "@type": "Organization",
        "name": "FoodStore",
        "contactPoint": {
          "@type": "ContactPoint",
          "telephone": "+91-9876543210",
          "email": "support@foodstore.in",
          "contactType": "customer support",
          "areaServed": "IN",
          "availableLanguage": ["en", "hi"]
        }
      }
    }
    </script>

    <style>
        .bg-home {
        padding: 100px 0;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <section class="bg-home d-flex align-items-center bg-light" style="height:auto;">
        <div class="container mt-lg-0 mt-sm-5  pt-lg-5 pt-sm-5">
            <div class="row g-4 align-items-center">
                
                <div class="col-lg-5 col-md-6">
                    <div class="bg-white px-4 py-5 rounded shadow">
                        <h4 class="card-title mb-4">Contact Us</h4>
                        
                        <asp:Label ID="lblMsg" runat="server"></asp:Label>

                        <div class="row g-3">
                            <div class="col-12">
                                <label class="form-label fw-normal">Your Name <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Name :" ValidationGroup="contact"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" ErrorMessage="Name is required" CssClass="text-danger small" Display="Dynamic" ValidationGroup="contact"></asp:RequiredFieldValidator>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-normal">Your Email <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Email :" TextMode="Email" ValidationGroup="contact"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required" CssClass="text-danger small" Display="Dynamic" ValidationGroup="contact"></asp:RequiredFieldValidator>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-normal">Your Phone <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="Mobile No :" MaxLength="10" ValidationGroup="contact"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhone" ErrorMessage="Phone is required" CssClass="text-danger small" Display="Dynamic" ValidationGroup="contact"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revPhone" runat="server" ControlToValidate="txtPhone" ErrorMessage="Invalid Mobile Number (10 digits)" CssClass="text-danger small" Display="Dynamic" ValidationGroup="contact" ValidationExpression="^[0-9]{10}$"></asp:RegularExpressionValidator>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-normal">Subject</label>
                                <asp:TextBox ID="txtSubject" runat="server" CssClass="form-control" placeholder="Subject :" ValidationGroup="contact"></asp:TextBox>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-normal">Comments <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtMessage" runat="server" CssClass="form-control" placeholder="Message :" TextMode="MultiLine" Rows="4" ValidationGroup="contact"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvMessage" runat="server" ControlToValidate="txtMessage" ErrorMessage="Message is required" CssClass="text-danger small" Display="Dynamic" ValidationGroup="contact"></asp:RequiredFieldValidator>
                            </div>
                        </div>

                        <div class="row mt-3">
                            <div class="col-12">
                                <div class="d-grid">
                                    <asp:Button ID="btnSubmit" runat="server" Text="Send Message" CssClass="btn btn-primary" OnClick="btnSubmit_Click" ValidationGroup="contact" UseSubmitBehavior="false" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-7 col-md-6">
    <div class="section-title ms-lg-5">
        <h3 class="title fw-medium mb-3">Have questions? <br> Get in touch!</h3>
        
        <p class="text-primary fw-bold">Want to join as a Seller? Send us a message here!</p>

        <p class="text-muted para-desc mb-0">Discover the best food stores and restaurants in your city. We help you find delicious meals, browse menus, and connect with top local eateries.</p>
        
        <div class="d-flex contact-detail align-items-center mt-3">
            <div class="icon">
                <i class="ri-mail-line fs-5 me-2"></i>
            </div>
            <div class="flex-1 content">
                <h6 class="fw-normal mb-0">Email</h6>
                <a href="mailto:support@foodstore.in" class="text-primary small">support@foodstore.in</a>
            </div>
        </div>
        
        <div class="d-flex contact-detail align-items-center mt-3">
            <div class="icon">
                <i class="ri-phone-line fs-5 me-2"></i>
            </div>
            <div class="flex-1 content">
                <h6 class="fw-normal mb-0">Phone</h6>
                <a href="tel:+919876543210" class="text-primary small">+91 987 654 3210</a>
            </div>
        </div>
        
        <div class="d-flex contact-detail align-items-center mt-3">
            <div class="icon">
                <i class="ri-map-pin-line fs-5 me-2"></i>
            </div>
            <div class="flex-1 content">
                <h6 class="fw-normal mb-0">Location</h6>
                <a href="https://goo.gl/maps/xyz" target="_blank" class="text-primary small">Bhilwara, Rajasthan, India</a>
            </div>
        </div>

        <ul class="list-unstyled social-icon foot-social-icon mb-0 mt-4">
            <li class="list-inline-item"><a href="#" class="btn btn-icon btn-sm btn-soft-primary rounded"><i class="ri-facebook-circle-line fs-6"></i></a></li>
            <li class="list-inline-item"><a href="#" class="btn btn-icon btn-sm btn-soft-primary rounded"><i class="ri-instagram-line fs-6"></i></a></li>
            <li class="list-inline-item"><a href="#" class="btn btn-icon btn-sm btn-soft-primary rounded"><i class="ri-twitter-x-line fs-6"></i></a></li>
        </ul>
    </div>
</div>
            </div>
        </div>
    </section>

</asp:Content>