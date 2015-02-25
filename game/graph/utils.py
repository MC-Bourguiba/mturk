from models import Node, Edge


def generate_graph(request):
    graphDict = request.POST.dict()
