import csv

class DataParser:
    def parse_data(self, filename):
        """Parses the raw data and extracts the patient ID and name.

        Args:
            filename: The name of the CSV file containing the raw data.

        Returns:
            A list of dictionaries, where each dictionary contains the patient ID and name.
        """

        with open(filename, 'r') as f:
            reader = csv.reader(f)
            next(reader)  # Skip the header row

            patient_data = []
            for row in reader:
                patient_data.append({
                    'patient_id': row[0],
                    'name': row[1]
                })

        return patient_data
