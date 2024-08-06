# model.py
import pickle
import warnings
warnings.filterwarnings("ignore", category=UserWarning, module="sklearn")
def load_model():
    # Load the model from the pickle file
    with open('chatbot_model.pkl', 'rb') as model_file:
        model = pickle.load(model_file)
    return model

def predict(question):
    model = load_model()
    # Replace with actual prediction code
    # Here we assume `model` has a `predict` method
    return model.predict([question])[0]
def simple_test():
    return "Nhập thành công"
