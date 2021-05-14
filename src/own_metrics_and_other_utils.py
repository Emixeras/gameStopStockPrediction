import numpy as np

def compute_average_change_per_timestep(data):

    """
    Computes average change from one timestep to the other in a set of values
    :param data: one column of values
    :return: average change
    """
    sum = 0
    for i in range(1, len(data)):
        sum += np.sqrt((data[i, 0] - data[i - 1, 0]) ** 2)
    sum = sum / (len(data) - 1)
    return sum


def mda(actual: np.ndarray, predicted: np.ndarray):
    """ Mean Directional Accuracy """
    return np.mean((np.sign(actual[1:] - actual[:-1]) == np.sign(predicted[1:] - predicted[:-1])).astype(int))