import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

Finura = 100
z = np.linspace(-1, 1, Finura)
phi = np.linspace(0, 2*np.pi, Finura)
theta = np.arccos(z)
theta, phi = np.meshgrid(theta, phi)

x = np.sin(theta)*np.cos(phi)
y = np.sin(theta)*np.sin(phi)
z = np.cos(theta)
theta_ini = (0, 0.5*np.pi, 0.5*np.pi, 0.5*np.pi)
theta_fin = (0.5*np.pi, 0.5*np.pi, 0.5*np.pi, 0)
phi_ini = (0, 0, 0, 0.5*np.pi)
phi_fin = (0, 0, 0.5*np.pi, 0.5*np.pi) #5*np.pi/16
arc_theta = [np.linspace(theta_ini[i], theta_fin[i], 100) for i in range(len(theta_fin))]
arc_phi = [np.linspace(phi_ini[i], phi_fin[i], 100) for i in range(len(theta_fin))]
r_labels = [1, 1, 1, 1]
offset_x = [0.3, 1.5, 1.3, 1]
offset_z = [1.2, 0.4, -1, 1]
x_fin = [np.sin(theta_fin[i])*np.cos(phi_fin[i]) for i in range(len(theta_fin))]
y_fin = [np.sin(theta_fin[i])*np.sin(phi_fin[i]) for i in range(len(theta_fin))]
z_fin = [np.cos(theta_fin[i]) for i in range(len(theta_fin))]

x_arc = [r_labels[i] * np.sin(arc_theta[i]) * np.cos(arc_phi[i]) for i in range(len(theta_fin))]
y_arc = [r_labels[i] * np.sin(arc_theta[i]) * np.sin(arc_phi[i]) for i in range(len(theta_fin))]
z_arc = [r_labels[i] * np.cos(arc_theta[i]) for i in range(len(theta_fin))]
arc_color = ["black"]*4
labels = [r"$\eta$", r"$\beta$", "", ""]
opacity = 0.15
ax_len = 1.4

Npoints = 1000
z_points = np.random.uniform(1, np.cos(0.5*np.pi), Npoints)
phi_points = np.random.uniform(0, 0.5*np.pi, Npoints)
theta_points = np.arccos(z_points)
x_points = np.sin(theta_points)*np.cos(phi_points)
y_points = np.sin(theta_points)*np.sin(phi_points)
fig = plt.figure()
ax = fig.add_subplot(111, projection="3d")
ax.plot_surface(x, y, z, color = 'yellow', alpha = opacity, edgecolor="none")
ax.plot([-ax_len, ax_len], [0, 0], [0, 0], linewidth=3, color = 'r')  # X-axis
ax.plot([0, 0], [-ax_len, ax_len], [0, 0], linewidth=3, color = 'r')  # Y-axis
ax.plot([0, 0], [0, 0], [-ax_len, ax_len], linewidth=3, color = 'r')  # Z-axis
ax.scatter(x_points, y_points, z_points, color = "blue", s=5)
for i in range(len(x_fin)):
    #ax.plot([0, r_labels[i]*x_fin[i]], [0, r_labels[i]*y_fin[i]], [0, r_labels[i]*z_fin[i]], linewidth=2.7, color=arc_color[i])
    ax.plot(x_arc[i], y_arc[i], z_arc[i], color=arc_color[i])
    #ax.text(offset_x[i]*np.average(x_arc[i]), 0.5*np.average(y_arc[i]), offset_z[i]*np.average(z_arc[i]), labels[i],color = arc_color[i])


# Add arrowheads for axes using quiver
arrow_length = 0.33
ax.quiver(ax_len - 0.2, 0, 0, arrow_length, 0, 0, color='r', linewidth=2.2)
ax.quiver(0, ax_len - 0.2, 0, 0, arrow_length, 0, color='r', linewidth=2.2)
ax.quiver(0, 0, ax_len - 0.2, 0, 0, arrow_length, color='r', linewidth=2.2)

# Add labels
ax.text(1.4, 0, 0.08, r"$a$", color='r', fontsize=12, fontweight='bold')
ax.text(0, 1.4, 0.08, r"$\mu$", color='r', fontsize=12, fontweight='bold')
ax.text(0.08, 0.08, 1.4, r"$\kappa$", color='r', fontsize=12, fontweight='bold')
#ax.text(x_fin, y_fin, z_fin + 0.08, 'R', color = "green", fontsize = 12, fontweight = 'bold')
# Add smooth polar and azimuthal lines
num_lines = 13  # Number of lines (every pi/3)
theta_values = np.linspace(0, 2*np.pi, num_lines, endpoint=False)  # Azimuthal angles
phi_values = np.linspace(0, np.pi, num_lines+1)[1:-1]  # Exclude poles for smooth latitudes

op_add = 0.15
# Add azimuthal (vertical) lines
v_fine = np.linspace(0, np.pi, 100)  # Fine grid for smooth curves
for theta in theta_values:
    x_az = np.cos(theta) * np.sin(v_fine)
    y_az = np.sin(theta) * np.sin(v_fine)
    z_az = np.cos(v_fine)
    ax.plot(x_az, y_az, z_az, 'green', linewidth=1, alpha = opacity + op_add)

# Add polar (horizontal) lines
u_fine = np.linspace(0, 2*np.pi, 100)  # Fine grid for smooth curves
for phi in phi_values:
    x_pol = np.cos(u_fine) * np.sin(phi)
    y_pol = np.sin(u_fine) * np.sin(phi)
    z_pol = np.cos(phi)
    ax.plot(x_pol, y_pol, z_pol, 'green', linewidth=1, alpha = opacity + op_add)
#fin for 

# Remove the 3D box (grid and background)
ax.set_xticks([])  # Remove x-axis ticks
ax.set_yticks([])  # Remove y-axis ticks
ax.set_zticks([])  # Remove z-axis ticks

ax.xaxis.pane.set_visible(False)  # Remove x pane
ax.yaxis.pane.set_visible(False)  # Remove y pane
ax.zaxis.pane.set_visible(False)  # Remove z pane

ax.set_box_aspect([1,1,1])
plt.show()
plt.close()

