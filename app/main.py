import tkinter as tk
from PIL import ImageTk, Image
from base_service import *


class FullscreenImageViewer:
    def __init__(self, root):
        self.config_service = ConfigServiceFactory.get_instance()

        self.images = self.config_service.get_value("files")
        self.folder_path = self.config_service.get_value("folder")

        self.root = root
        self.current_image_index = 0

        self.root.attributes("-fullscreen", True)
        self.root.bind("<Escape>", self.exit_fullscreen)  # Escape zum Beenden des Vollbildmodus

        self.image_label = tk.Label(self.root)
        self.image_label.pack(expand=True)

        self.root.resizable(True, True)
        self.root.after(20 * 1000, self.update_files)
        self.root.after(300, lambda: root.attributes("-fullscreen", True))

        self.next_image()

    def update_files(self):
        self.config_service.update_files()
        self.images = self.config_service.get_value("files")
        self.root.after(20 * 1000, self.update_files)

    def show_image(self):
        if self.images:
            path = f"{self.folder_path}/{self.images[self.current_image_index]['name']}"
            image = Image.open(path)
            image = image.resize((self.root.winfo_width(), self.root.winfo_height()), Image.LANCZOS)
            self.photo = ImageTk.PhotoImage(image)
            self.image_label.config(image=self.photo)
            self.image_label.image = self.photo  # Referenz speichern

    def set_timer(self):
        current_interval = self.images[self.current_image_index]["duration"]
        self.root.after(current_interval * 1000, self.next_image)

    def next_image(self):
        self.update_files()
        self.show_image()
        self.set_timer()
        self.current_image_index = (self.current_image_index + 1) % len(self.images)
        while not self.images[self.current_image_index]["active"]:
            print(self.current_image_index)
            self.current_image_index = (self.current_image_index + 1) % len(self.images)

    def exit_fullscreen(self, event):
        self.root.attributes("-fullscreen", False)


if __name__ == "__main__":
    root = tk.Tk()
    viewer = FullscreenImageViewer(root)
    root.mainloop()
