import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import sqlite3

class DatabaseApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Database Viewer")
        self.create_gui()
        self.connect_db()

    def create_gui(self):
        self.main_frame = ttk.Frame(self.root)
        self.main_frame.pack(fill=tk.BOTH, expand=True)

        self.toolbox_frame = ttk.Frame(self.main_frame)
        self.toolbox_frame.pack(side=tk.LEFT, fill=tk.Y, padx=10, pady=10)

        self.frame = ttk.Frame(self.main_frame)
        self.frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

        self.tree = ttk.Treeview(self.frame)
        self.tree.pack(fill=tk.BOTH, expand=True, side=tk.LEFT)

        self.scrollbar = ttk.Scrollbar(self.frame, orient=tk.VERTICAL, command=self.tree.yview)
        self.scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        self.tree.configure(yscrollcommand=self.scrollbar.set)

        self.button_frame = ttk.Frame(self.root)
        self.button_frame.pack(fill=tk.X)

        tables = ["ArcherData", "Equipment", "Class", "RangeData", "Category", "ChampionShip", "Competition", "RoundTypeData", "RoundData", "EndData", "SystemData"]
        for table in tables:
            button = ttk.Button(self.button_frame, text=table, command=lambda t=table: self.show_table(t))
            button.pack(side=tk.LEFT, padx=5, pady=5)

        self.menu = tk.Menu(self.root)
        self.root.config(menu=self.menu)
        self.file_menu = tk.Menu(self.menu)
        self.menu.add_cascade(label="File", menu=self.file_menu)
        self.file_menu.add_command(label="Open SQL File", command=self.load_sql_file)
        self.file_menu.add_separator()
        self.file_menu.add_command(label="Exit", command=self.root.quit)

        # Add query input fields and button
        ttk.Label(self.toolbox_frame, text="ArcherID:").pack(anchor=tk.W)
        self.archer_id_entry = ttk.Entry(self.toolbox_frame)
        self.archer_id_entry.pack(fill=tk.X)

        ttk.Label(self.toolbox_frame, text="CompID:").pack(anchor=tk.W)
        self.comp_id_entry = ttk.Entry(self.toolbox_frame)
        self.comp_id_entry.pack(fill=tk.X)

        self.run_query_button = ttk.Button(self.toolbox_frame, text="Run Query", command=self.run_custom_query)
        self.run_query_button.pack(pady=10)

    def connect_db(self):
        self.conn = sqlite3.connect(':memory:')
        self.cursor = self.conn.cursor()
        self.create_tables()

    def create_tables(self):
        sql_commands = """
        CREATE TABLE IF NOT EXISTS ArcherData (
            ArcherID VARCHAR(50) NOT NULL,
            ArcName VARCHAR(50) NOT NULL,
            DOB DATE NOT NULL,
            Gender VARCHAR(50) NOT NULL,
            CONSTRAINT pk_ArcherData PRIMARY KEY (ArcherID)
        );

        CREATE TABLE IF NOT EXISTS Equipment (
            EquipID VARCHAR(4) NOT NULL,
            EquipDesc VARCHAR(50) NOT NULL,
            CONSTRAINT pk_Equipment PRIMARY KEY (EquipID)
        );

        CREATE TABLE IF NOT EXISTS Class (
            ClassID VARCHAR(50) NOT NULL,
            ClassDesc VARCHAR(50) NOT NULL,
            CONSTRAINT pk_Class PRIMARY KEY (ClassID)
        );

        CREATE TABLE IF NOT EXISTS RangeData (
            RangeID VARCHAR(50) NOT NULL,
            Distance INT NOT NULL,
            ArrowNumber INT NOT NULL,
            TargetFace INT NOT NULL,
            CONSTRAINT pk_RangeData PRIMARY KEY (RangeID)
        );

        CREATE TABLE IF NOT EXISTS Category (
            ClassID VARCHAR(50) NOT NULL,
            EquipID VARCHAR(4) NOT NULL,
            CategoryDesc VARCHAR(50) NOT NULL,
            CONSTRAINT pk_Category PRIMARY KEY (ClassID, EquipID),
            CONSTRAINT fk_Category_Class FOREIGN KEY (ClassID) REFERENCES Class(ClassID),
            CONSTRAINT fk_Category_Equipment FOREIGN KEY (EquipID) REFERENCES Equipment(EquipID)
        );
        CREATE INDEX IF NOT EXISTS idx_Category_ClassID ON Category(ClassID);
        CREATE INDEX IF NOT EXISTS idx_Category_EquipID ON Category(EquipID);

        CREATE TABLE IF NOT EXISTS ChampionShip (
            ChampionShipID VARCHAR(50) NOT NULL,
            ChampionShipName VARCHAR(50) NOT NULL,
            YearOfChampionShip INT(4) NOT NULL,
            CONSTRAINT pk_ChampionShip PRIMARY KEY (ChampionShipID)
        );

        CREATE TABLE IF NOT EXISTS Competition (
            CompID VARCHAR(50) NOT NULL,
            ChampionShipID VARCHAR(50),
            CompName VARCHAR(50) NOT NULL,
            CompDesc VARCHAR(50) NOT NULL,
            CONSTRAINT pk_Competition PRIMARY KEY (CompID),
            CONSTRAINT fk_Competition_ChampionShip FOREIGN KEY (ChampionShipID) REFERENCES ChampionShip(ChampionShipID)
        );
        CREATE INDEX IF NOT EXISTS idx_Competition_ChampionShipID ON Competition(ChampionShipID);

        CREATE TABLE IF NOT EXISTS RoundTypeData (
            RoundType VARCHAR(50) NOT NULL,
            RoundTypeDesc VARCHAR(50) NOT NULL,
            CONSTRAINT pk_RoundTypeData PRIMARY KEY (RoundType)
        );

        CREATE TABLE IF NOT EXISTS RoundData (
            RoundID VARCHAR(50) NOT NULL,
            RoundType VARCHAR(50) NOT NULL,
            RangeID VARCHAR(50) NOT NULL,
            CompID VARCHAR(50) NOT NULL,
            RoundName VARCHAR(50) NOT NULL,
            PossibleScore INT NOT NULL,
            CONSTRAINT pk_RoundData PRIMARY KEY (RoundID, RangeID),
            CONSTRAINT fk_RoundData_RangeData FOREIGN KEY (RangeID) REFERENCES RangeData(RangeID),
            CONSTRAINT fk_RoundData_RoundTypeData FOREIGN KEY (RoundType) REFERENCES RoundTypeData(RoundType),
            CONSTRAINT fk_RoundData_Competition FOREIGN KEY (CompID) REFERENCES Competition(CompID)
        );
        CREATE INDEX IF NOT EXISTS idx_RoundData_RoundType ON RoundData(RoundType);
        CREATE INDEX IF NOT EXISTS idx_RoundData_CompID ON RoundData(CompID);

        CREATE TABLE IF NOT EXISTS EndData (
            RoundID VARCHAR(50) NOT NULL,
            RangeID VARCHAR(50) NOT NULL,
            EndID VARCHAR(50) NOT NULL,
            Arrow1 INT(2) NOT NULL,
            Arrow2 INT(2) NOT NULL,
            Arrow3 INT(2) NOT NULL,
            Arrow4 INT(2) NOT NULL,
            Arrow5 INT(2) NOT NULL,
            Arrow6 INT(2) NOT NULL,
            Approved BOOLEAN NOT NULL DEFAULT FALSE,
            CONSTRAINT pk_EndData PRIMARY KEY (RoundID, RangeID, EndID),
            CONSTRAINT fk_EndData_RoundData FOREIGN KEY (RoundID, RangeID) REFERENCES RoundData (RoundID, RangeID)
        );
        CREATE INDEX IF NOT EXISTS idx_EndData_RoundID ON EndData(RoundID);
        CREATE INDEX IF NOT EXISTS idx_EndData_RangeID ON EndData(RangeID);

        CREATE TABLE IF NOT EXISTS SystemData (
            ArcherID VARCHAR(50) NOT NULL,
            ClassID VARCHAR(50) NOT NULL,
            EquipID VARCHAR(4) NOT NULL,
            RoundID VARCHAR(50) NOT NULL,
            RangeID VARCHAR(50) NOT NULL,
            CompID VARCHAR(50),
            EndID VARCHAR(50) NOT NULL,
            DateInfo DATE NOT NULL,
            CONSTRAINT pk_SystemData PRIMARY KEY (ArcherID, ClassID, EquipID, RoundID, RangeID, CompID, EndID),
            CONSTRAINT fk_SystemData_ArcherData FOREIGN KEY (ArcherID) REFERENCES ArcherData(ArcherID),
            CONSTRAINT fk_SystemData_Category FOREIGN KEY (ClassID, EquipID) REFERENCES Category(ClassID, EquipID),
            CONSTRAINT fk_SystemData_EndData FOREIGN KEY (RoundID, RangeID, EndID) REFERENCES EndData(RoundID, RangeID, EndID),
            CONSTRAINT fk_SystemData_Competition FOREIGN KEY (CompID) REFERENCES Competition(CompID)
        );
        CREATE INDEX IF NOT EXISTS idx_SystemData_ArcherID ON SystemData(ArcherID);
        CREATE INDEX IF NOT EXISTS idx_SystemData_ClassID ON SystemData(ClassID);
        CREATE INDEX IF NOT EXISTS idx_SystemData_EquipID ON SystemData(EquipID);
        CREATE INDEX IF NOT EXISTS idx_SystemData_RoundID ON SystemData(RoundID);
        CREATE INDEX IF NOT EXISTS idx_SystemData_RangeID ON SystemData(RangeID);
        CREATE INDEX IF NOT EXISTS idx_SystemData_CompID ON SystemData(CompID);
        CREATE INDEX IF NOT EXISTS idx_SystemData_EndID ON SystemData(EndID);
        CREATE INDEX IF NOT EXISTS idx_SystemData_DateInfo ON SystemData(DateInfo);
        """
        self.cursor.executescript(sql_commands)
        self.conn.commit()

    def load_sql_file(self):
        file_path = filedialog.askopenfilename(filetypes=[("SQL Files", "*.sql")])
        if not file_path:
            return
        with open(file_path, 'r') as sql_file:
            sql_script = sql_file.read()
        try:
            self.cursor.executescript(sql_script)
            self.conn.commit()
            messagebox.showinfo("Success", "SQL file loaded successfully.")
        except sqlite3.Error as e:
            messagebox.showerror("Error", f"An error occurred: {e}")

    def show_table(self, table_name):
        try:
            self.cursor.execute(f"SELECT * FROM {table_name}")
            rows = self.cursor.fetchall()
            columns = [description[0] for description in self.cursor.description]

            # Clear previous content in treeview
            self.tree.delete(*self.tree.get_children())

            # Set up columns and headings
            self.tree["columns"] = columns
            for col in columns:
                self.tree.heading(col, text=col, anchor=tk.W)
                self.tree.column(col, width=100, anchor=tk.W)

            # Insert rows into treeview
            for row in rows:
                self.tree.insert("", "end", values=row)

        except sqlite3.Error as e:
            messagebox.showerror("Error", f"An error occurred: {e}")

    def run_custom_query(self):
        archer_id = self.archer_id_entry.get().strip()
        comp_id = self.comp_id_entry.get().strip()

        if not archer_id or not comp_id:
            messagebox.showwarning("Input Error", "Please provide both ArcherID and CompID.")
            return

        query = f"""
        SELECT Sys.ArcherID, Sys.ClassID, Sys.EquipID, Sys.RoundID, Sys.RangeID, Sys.EndID, Sys.DateInfo,
               E.Arrow1, E.Arrow2, E.Arrow3, E.Arrow4, E.Arrow5, E.Arrow6
        FROM SystemData Sys
        JOIN EndData E ON Sys.RoundID = E.RoundID AND Sys.RangeID = E.RangeID AND Sys.EndID = E.EndID
        WHERE Sys.ArcherID = '{archer_id}' AND Sys.CompID = '{comp_id}';
        """

        try:
            self.cursor.execute(query)
            rows = self.cursor.fetchall()
            columns = [description[0] for description in self.cursor.description]

            # Clear previous content in treeview
            self.tree.delete(*self.tree.get_children())

            # Set up columns and headings
            self.tree["columns"] = columns
            for col in columns:
                self.tree.heading(col, text=col, anchor=tk.W)
                self.tree.column(col, width=100, anchor=tk.W)

            # Insert rows into treeview
            for row in rows:
                self.tree.insert("", "end", values=row)

        except sqlite3.Error as e:
            messagebox.showerror("Error", f"An error occurred: {e}")

def main():
    root = tk.Tk()
    app = DatabaseApp(root)
    root.mainloop()

if __name__ == "__main__":
    main()
