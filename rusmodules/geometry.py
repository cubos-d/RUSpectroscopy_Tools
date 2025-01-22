import numpy as np
import matplotlib.pyplot as plt

def generate_sphere_surface_points_random(N, max_theta, max_phi, options = {"theta": False, "phi": False}):
    """
    Generates N random points uniformly distributed in the surface of a sphere,
    between 0 and max_theta for the polar angle and 0 and max_phi for the 
    azimutal angle. 

    Arguments:
    N -- <int>: Number of points to be generaetd
    max_theta -- <float>: Upper bound of the polar angle
    max_phi -- <float>: Upper bound of the azimutal angle
    options -- <dict>: Irrelevant in this function. To be removed soon

    Returns: 
    points -- <np.array>: The points generated, represented in each row
        of the matrix. The first column is the polar angle and the
        second column is the azimuthal angle. 
    """
    min_z = np.cos(max_theta) 
    z = min_z + (1 - min_z)*np.random.rand(N)
    phi = np.random.uniform(0, max_phi, N)
    theta = np.arccos(z)
    return np.c_[theta, phi]
#fin generate_shpere_random

def generate_sphere_surface_points(N, max_theta, max_phi, options = {"theta": False, "phi": False}):
    """
    Generates approximately N points (not random) uniformly distributed over the 
    surface of a sphere between 0 and max_theta (for the polar angle) and 
    between 0 and max_phi (for the azimuthal angle). 

    Arguments:
    N -- <int>: Approximate number of points to be generated
    max_theta -- <float>: Upper bound of the polar angle
    max_phi -- <float>: Upper bound of the azimutal angle
    options -- <dict>: Check if the max_eta or max_theta will be included in the 
        interval of generation of points. By default none of these will be 
        included

    Returns: 
    points -- <np.array>: The points generated, represented in each row
        of the matrix. The first column is the polar angle and the
        second column is the azimuthal angle. 
    """
    Omega = (max_phi * (1 - np.cos(max_theta))) / N
    d_med = Omega**(1/2)
    N_latitudes = int(max_theta/d_med)
    delta_theta = max_theta/N_latitudes
    delta_phi = Omega/delta_theta
    max_theta_space = max_theta if options["theta"] else max_theta*(1 - 1/N_latitudes)
    rango_theta = np.linspace(max_theta/N_latitudes, max_theta_space, N_latitudes)
    resp = []
    for i, theta in enumerate(rango_theta):
        N_longitudes = int(max_phi*np.sin(theta)/delta_phi)
        max_phi_space = max_phi if options["phi"] else max_phi*(1 - 1/N_longitudes)
        rango_phi = np.linspace(max_phi/N_longitudes, max_phi_space, N_longitudes)
        for j, phi in enumerate(rango_phi):
            resp.append([theta, phi])
        #fin for 
    #fin for
    return np.array(resp)
#fin función

if __name__ == "__main__":
    #combi = generate_sphere_surface_points(4, 0.5*np.pi, np.pi, options = {"theta": True, "phi": True})
    combi = generate_sphere_surface_points_random(5000, 0.5*np.pi, np.pi, options = {"theta": True, "phi": True})
    print(combi)
    print("Número de puntos")
    print(len(combi))
    x = np.sin(combi[:,0])*np.cos(combi[:,1])
    y = np.sin(combi[:,0])*np.sin(combi[:,1])
    z = np.cos(combi[:,0])
    fig = plt.figure()
    ax = fig.add_subplot(111, projection = "3d")
    ax.scatter(x,y,z)
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    plt.show()
    
