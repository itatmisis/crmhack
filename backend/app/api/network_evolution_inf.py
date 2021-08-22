import os
from pathlib import Path
import pickle

from scipy import spatial
from gensim.models.doc2vec import Doc2Vec
import networkx as nx
from io import BytesIO
from celluloid import Camera  # getting the camera
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.image as mpimg


DATA = Path(os.path.realpath(__file__)).parent.parent / "data"
TMP = Path('/tmp')
model = Doc2Vec.load(str(DATA / "doc2vec_rev1.model"))

def get_rand_name():
    rand = np.random.randint(100, 1000)
    to_return = TMP / ("animation_" + str(rand) + ".gif")
    return str(to_return)

empirical = pickle.load(open(DATA / 'empirical.pkl', 'rb'))
etalon = pickle.load(open(DATA / 'empirical.pkl', 'rb'))

etalon_list = [[0, 1],
               [1, 2],
               [1, 3],
               [1, 4],
               [1, 5],
               [2, 3],
               [2, 5],
               [3, 4],
               [3, 5],
               [4, 5],
               [4, 6],
               [4, 7],
               [5, 6],
               [5, 7],
               [6, 7],
               [5, 8],
               [6, 8],
               [7, 7],
               [8, 8]]
etalon_list = [tuple(etalon_list[i]) for i in range(len(etalon_list))]

node_count = 9

edge_counter = {etalon_list[i]: 1 for i in range(len(etalon_list))}


def get_distance(input_1, input_2) -> float:
    dist = 0
    for j in range(20):
        vec1 = model.infer_vector(input_1.split())
        vec2 = model.infer_vector(input_2.split())
        dist += spatial.distance.cosine(vec1, vec2)
    dist /= 20
    return dist


def add_edge(edge_counter, node1, node2):
    if (node1, node2) in edge_counter:
        #        print("Exist!")
        edge_counter[(node1, node2)] += 1
    else:
        #        print("Not exist!")
        edge_counter[(node1, node2)] = 1
    return edge_counter


thrash = 0.1
global_marking = []
result = etalon.copy()
for i in range(len(empirical)):
    this_try = empirical[i]
    marking = []
    #    print(i)
    for j in range(len(empirical[i])):

        marking.append(-1)
        curr_min = 100
        for k in range(node_count):
            dist = get_distance(empirical[i][j], etalon[k])

            if (dist < thrash and dist < curr_min):
                curr_min = dist
                #                print(i, j, k, dist)
                marking[j] = k

    for j in range(len(empirical[i])):

        if (marking[j] == -1):
            node_count += 1
            etalon.append(empirical[i][j])
            # print(node_count, empirical[i][j])

        if (j != 0):
            if (marking[j - 1] == -1 and marking[j] == -1):
                #                print("Adding edge ", j, node_count,  node_count-1)
                edge_counter = add_edge(edge_counter, node_count, node_count - 1)
            else:
                if (marking[j] == -1 and marking[j - 1] != -1):
                    #                    print("Adding edge ", j, marking[j-1], node_count)
                    edge_counter = add_edge(edge_counter, marking[j - 1], node_count)

                if (marking[j] != -1 and marking[j - 1] == -1):
                    #                    print("Adding edge ", j, marking[j], node_count)
                    edge_counter = add_edge(edge_counter, marking[j], node_count)

                if (marking[j] != -1 and marking[j - 1] != -1):
                    #                    print("Adding edge ", j, marking[j], marking[j-1])
                    edge_counter = add_edge(edge_counter, marking[j], marking[j - 1])

        else:
            if (marking[j] != -1 and marking[j + 1] == -1):
                #                print("Adding edge (", j, marking[j], "). With number ",  node_count+1)
                edge_counter = add_edge(edge_counter, marking[j], node_count + 1)

    global_marking.append(marking)


def get_graph(edge_counter, ec_dict):
    g = nx.Graph()
    weights = [pow(list(ec_dict.values())[i], -1) for i in range(len(list(ec_dict.values())))]

    for i in range(len(edge_counter)):
        g.add_edge(list(edge_counter)[i][0], list(edge_counter)[i][1], weight=weights[i])

    nx.draw_spring(g, with_labels=True)
    to_pdot = nx.drawing.nx_pydot.to_pydot
    pdot = to_pdot(g)
    shapes = ['box', 'polygon', 'ellipse', 'oval', 'circle', 'egg', 'triangle', 'exagon', 'star', ]
    colors = ['blue', 'black', 'red', '#db8625', 'green', 'gray', 'cyan', '#ed125b']
    styles = ['filled', 'rounded', 'rounded, filled', 'dashed', 'dotted, bold']

    g_c = g.copy()
    g_c.remove_node(8)
    optimal_path = nx.dijkstra_path(g_c, 0, 7)
    # print(optimal_path)

    # for i, edge in enumerate(pdot.get_edges()):
    # print(edge)
    for i, edge in enumerate(pdot.get_edges()):
        edge.set_penwidth(1.5)

    for i in range(len(optimal_path) - 1):
        # print(pdot.get_edge(str(optimal_path[i]), str(optimal_path[i + 1])))
        pdot.get_edge(str(optimal_path[i]), str(optimal_path[i + 1]))[0].set_penwidth(6)
        pdot.get_edge(str(optimal_path[i]), str(optimal_path[i + 1]))[0].set_color("blue")

    for i in range(len(optimal_path)):
        pdot.get_node(str(optimal_path[i]))[0].set_color("blue")
        pdot.get_node(str(optimal_path[i]))[0].set_penwidth(4)

    for i, node in enumerate(pdot.get_nodes()):
        node.set_shape(shapes[4])
        if (i == 0):
            node.set_label("Start")

        if (i == 7):
            node.set_label("Success")

        if (i == 8):
            node.set_label("Fail")

        if (i < 9):
            node.set_fontsize(20)
            node.set_fillcolor("#877df5")
            node.set_style(styles[0])

    png_str = pdot.create_png(prog='dot')
    sio = BytesIO()
    sio.write(png_str)
    sio.seek(0)
    img = mpimg.imread(sio)

    return img


def generate_gif():
    graphs = [get_graph(list(edge_counter)[0:i], edge_counter) for i in
              range(17, len(list(edge_counter)), int((len(list(edge_counter)) - 17) / 5))]

    fig, ax = plt.subplots(figsize=(12, 12))  # make it bigger
    camera = Camera(fig)  # the camera gets our figure
    for img in graphs:
        img_obj = img
        ax.imshow(img_obj)  # plotting
        camera.snap()
    animation = camera.animate(interval=1500)

    name = get_rand_name()
    animation.save(name)

    return name