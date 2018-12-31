import os
folder = os.getcwd()
run = True

def menu():
    print("Select the action:")
    print("1 - View atual folder")
    print("2 - Change the atual folder")
    print("3 - Destroy files")
    print("4 - Close")
    action = int(input())
    if(action == 1):
        view()
    if(action == 2):
        change()
    if(action == 3):
        destroy()
    if(action == 4):
        close()

def view():
    global folder
    print("Atual Folder: "+folder)
    aux = input()

def change():
    global folder
    print("New folder: ")
    newDir = input()
    if(os.path.isdir(newDir)):
        folder = newDir

def destroy():
    pass

def close():
    global run
    run = False

if __name__ == '__main__':
    while(run):
        menu()
