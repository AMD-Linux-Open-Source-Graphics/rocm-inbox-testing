import torch

def test_basic():
    assert torch.cuda.is_available()

def test_rand():

    d = torch.device('cuda')
    a = torch.rand(1, 2).to(d)

    assert a.shape == (1, 2)
    assert a[0, 0] >= 0 and a[0, 0] < 1
    assert a[0, 1] >= 0 and a[0, 1] < 1