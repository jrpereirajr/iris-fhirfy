from fhir.resources.bundle import Bundle
from fhir.resources.patient import Patient
from fhir.resources.fhirtypes import BundleEntryRequestType

class FHIRBundleCreator:
    def create_fhir_bundle(self, patient_data):
        """Creates a FHIR Bundle resource from the parsed data.

        Args:
            patient_data: A list of dictionaries, where each dictionary contains the patient ID and name.

        Returns:
            A FHIR Bundle resource.
        """

        bundle_data = {
            "type": "transaction",
            "entry": []
        }
        bundle = Bundle(**bundle_data)

        for patient in patient_data:
            fhir_patient = Patient()
            fhir_patient.id = patient['patient_id']
            fhir_patient.name = [{'family': patient['name']}]

            fhir_request = BundleEntryRequestType({
                "method": "POST",
                "url": "Patient"
            })

            bundle.entry.append({
                'resource': fhir_patient,
                'request': fhir_request
            })

        return bundle
