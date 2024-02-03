from data_parser import DataParser
from fhir_bundle_creator import FHIRBundleCreator

def main():
    # Parse the raw data
    data_parser = DataParser()
    patient_data = data_parser.parse_data('data.csv')

    # Create a FHIR Bundle resource
    fhir_bundle_creator = FHIRBundleCreator()
    fhir_bundle = fhir_bundle_creator.create_fhir_bundle(patient_data)

    # Save the FHIR Bundle resource to a file
    with open('fhir_bundle.json', 'w') as f:
        f.write(fhir_bundle.json())

if __name__ == '__main__':
    main()
