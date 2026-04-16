<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/admin/AdminMaster.master" AutoEventWireup="true" CodeFile="dashboard.aspx.cs" Inherits="admin_dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">

    <style>
        .dashboard-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .date-badge { background: #fff; padding: 8px 15px; border-radius: 30px; font-size: 13px; font-weight: 600; color: #555; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }

        /* STATS CARDS */
        .stat-card { border-radius: 16px; padding: 25px; color: white; position: relative; overflow: hidden; box-shadow: 0 10px 20px rgba(0,0,0,0.1); transition: transform 0.3s ease; border: none; margin-bottom: 25px; }
        .stat-card:hover { transform: translateY(-5px); }
        .stat-card h3 { font-size: 32px; font-weight: 700; margin: 5px 0 0 0; }
        .stat-card p { font-size: 14px; opacity: 0.8; margin: 0; text-transform: uppercase; letter-spacing: 1px; }
        .stat-icon { position: absolute; right: 20px; top: 50%; transform: translateY(-50%); font-size: 50px; opacity: 0.2; }

        /* GRADIENTS */
        .bg-gradient-blue { background: linear-gradient(45deg, #1e3c72, #2a5298); }
        .bg-gradient-purple { background: linear-gradient(45deg, #8e44ad, #c0392b); }
        .bg-gradient-green { background: linear-gradient(45deg, #11998e, #38ef7d); }
        .bg-gradient-red { background: linear-gradient(45deg, #cb2d3e, #ef473a); }

        /* CHARTS & TABLE */
        .chart-card { background: white; border-radius: 16px; padding: 20px; box-shadow: 0 5px 20px rgba(0,0,0,0.03); margin-bottom: 25px; height: 100%; }
        .card-title { font-size: 16px; font-weight: 700; color: #333; margin-bottom: 20px; border-bottom: 1px solid #f0f0f0; padding-bottom: 10px; }
        
        .recent-table { width: 100%; border-collapse: collapse; }
        .recent-table th { text-align: left; padding: 12px; color: #888; font-size: 12px; text-transform: uppercase; border-bottom: 1px solid #eee; }
        .recent-table td { padding: 12px; font-size: 14px; border-bottom: 1px solid #f9f9f9; color: #444; }
        .status-pill { padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; }
        .pill-pending { background: #fff3cd; color: #856404; }
        .pill-active { background: #d4edda; color: #155724; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div class="dashboard-header">
        <div>
            <h4 class="fw-bold text-dark m-0">Dashboard Overview</h4>
            <small class="text-muted">Welcome back, Admin</small>
        </div>
        <div class="date-badge">
            <i class="fas fa-calendar-alt me-2 text-primary"></i> <%= DateTime.Now.ToString("dd MMM yyyy") %>
        </div>
    </div>

    <div class="row">
        <div class="col-md-3">
            <div class="stat-card bg-gradient-blue">
                <div class="stat-content">
                    <p>Total Cities</p>
                    <asp:Label ID="lblCities" runat="server" Text="0"><h3>0</h3></asp:Label>
                </div>
                <div class="stat-icon"><i class="fas fa-map-marked-alt"></i></div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card bg-gradient-purple">
                <div class="stat-content">
                    <p>Categories</p>
                    <asp:Label ID="lblCategories" runat="server" Text="0"><h3>0</h3></asp:Label>
                </div>
                <div class="stat-icon"><i class="fas fa-layer-group"></i></div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card bg-gradient-green">
                <div class="stat-content">
                    <p>Live Outlets</p>
                    <asp:Label ID="lblActiveRest" runat="server" Text="0"><h3>0</h3></asp:Label>
                </div>
                <div class="stat-icon"><i class="fas fa-store"></i></div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card bg-gradient-red">
                <div class="stat-content">
                    <p>Pending</p>
                    <asp:Label ID="lblPending" runat="server" Text="0"><h3>0</h3></asp:Label>
                </div>
                <div class="stat-icon"><i class="fas fa-user-clock"></i></div>
            </div>
        </div>
    </div>

    <div class="row">
        
        <div class="col-lg-8">
            <div class="chart-card">
                <div class="d-flex justify-content-between">
                    <div class="card-title">Platform Growth (Current Year)</div>
                </div>
                <canvas id="growthChart" height="120"></canvas>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="chart-card">
                <div class="card-title">Data Distribution</div>
                <canvas id="pieChart" height="200"></canvas>
                
                <hr class="mt-4 mb-3" />
                
                <h6 class="text-muted small fw-bold mb-3">QUICK ACTIONS</h6>
                <div class="d-grid gap-2">
                    <a href="AddCity.aspx" class="btn btn-outline-primary btn-sm text-start">
                        <i class="fas fa-plus-circle me-2"></i> Add New City
                    </a>
                    <a href="PendingRestaurants.aspx" class="btn btn-outline-danger btn-sm text-start">
                        <i class="fas fa-exclamation-circle me-2"></i> Review Approvals
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <div class="chart-card p-0 overflow-hidden">
                <div class="p-3 border-bottom bg-light">
                    <h6 class="m-0 fw-bold text-dark">Recent Registrations</h6>
                </div>
                <div class="table-responsive">
                    <table class="recent-table">
                        <thead>
                            <tr>
                                <th>Restaurant</th>
                                <th>City</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptRecent" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <i class="fas fa-utensils text-secondary me-2"></i> 
                                            <span class="fw-bold text-dark"><%# Eval("Name") %></span>
                                        </td>
                                        <td><%# Eval("CityName") %></td>
                                        <td><%# Convert.ToDateTime(Eval("RegistrationDate")).ToString("dd MMM yyyy") %></td>
                                        <td>
                                            <%# GetStatusBadge(Eval("ApprovalStatus")) %>
                                        </td>
                                        <td>
                                            <a href="RestaurantDetails.aspx?id=<%# Eval("RestaurantID") %>" 
                                               class="btn btn-xs btn-light py-0 text-dark border" style="font-size:11px;">
                                               Details
                                            </a>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                    <tr id="Tr1" runat="server" visible='<%# rptRecent.Items.Count == 0 %>'>
                                        <td colspan="5" class="text-center text-muted p-4">No recent activity found.</td>
                                    </tr>
                                </FooterTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="hfLiveCount" runat="server" Value="0" />
    <asp:HiddenField ID="hfPendingCount" runat="server" Value="0" />
    <asp:HiddenField ID="hfGrowthLabels" runat="server" />
    <asp:HiddenField ID="hfGrowthData" runat="server" />

    <script>
        // --- 1. GROWTH CHART (Dynamic) ---
        // Get data string from C# and split into array
        var rawLabels = document.getElementById('<%= hfGrowthLabels.ClientID %>').value;
        var rawData = document.getElementById('<%= hfGrowthData.ClientID %>').value;

        var gLabels = rawLabels ? rawLabels.split(',') : [];
        var gData = rawData ? rawData.split(',') : [];

    const ctxGrowth = document.getElementById('growthChart').getContext('2d');
    const growthChart = new Chart(ctxGrowth, {
        type: 'line',
        data: {
            labels: gLabels, // Dynamic Labels (Jan, Feb...)
            datasets: [{
                label: 'New Restaurants',
                data: gData, // Dynamic Data (5, 10...)
                borderColor: '#1e3c72', // Existing Dark Blue
                backgroundColor: 'rgba(30, 60, 114, 0.1)', // Existing Light Blue fill
                borderWidth: 2,
                fill: true,
                tension: 0.4
            }]
        },
        options: {
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, ticks: { stepSize: 1 }, grid: { borderDash: [5, 5] } },
                x: { grid: { display: false } }
            }
        }
    });

        // --- 2. PIE CHART (Dynamic) ---
        var liveVal = parseInt(document.getElementById('<%= hfLiveCount.ClientID %>').value);
    var pendingVal = parseInt(document.getElementById('<%= hfPendingCount.ClientID %>').value);

    const ctxPie = document.getElementById('pieChart').getContext('2d');
    const pieChart = new Chart(ctxPie, {
        type: 'doughnut',
        data: {
            labels: ['Active', 'Pending'],
            datasets: [{
                data: [liveVal, pendingVal],
                // Colors changed to Blue Theme:
                // Active = Dark Blue (#1e3c72), Pending = Lighter Blue (#6dd5ed)
                backgroundColor: ['#1e3c72', '#6dd5ed'],
                borderWidth: 0
            }]
        },
        options: {
            cutout: '70%',
            plugins: { legend: { position: 'bottom', labels: { usePointStyle: true, padding: 20 } } }
        }
    });
</script>

</asp:Content>