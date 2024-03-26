#include <stdio.h>
#include <pthread.h>
#include <Python.h>

typedef void (*Hukla)(int);
Hukla huk1;

PyThreadState *mainThreadState;

void python_finalize() {
    PyEval_RestoreThread(mainThreadState);
    Py_Finalize();
}

void hello(Hukla huk) {
    huk1 = huk;
}

static PyObject* my_func(PyObject* self, PyObject* args) {
    huk1(10);
    return Py_BuildValue("i", 42);
}

static PyMethodDef mymodule_methods[] = {
    {"my_func", my_func, METH_VARARGS, "Description of my_function"},
    {NULL, NULL, 0, NULL}
};

static struct PyModuleDef mymodule_module = {
    PyModuleDef_HEAD_INIT,
    "mymodule",
    NULL,
    -1,
    mymodule_methods
};

PyMODINIT_FUNC PyInit_mymodule(void) {
    return PyModule_Create(&mymodule_module);
}

void ctart() {
    PyGILState_STATE gilState;
    gilState = PyGILState_Ensure();
    PyRun_SimpleString("import mymodule\n"
        "print(\"python\")\n"
        "print(mymodule.my_func())");
    PyGILState_Release(gilState);
}

void python_init() {
    PyImport_AppendInittab("mymodule", &PyInit_mymodule);
    Py_Initialize();
    mainThreadState = PyEval_SaveThread();
}
