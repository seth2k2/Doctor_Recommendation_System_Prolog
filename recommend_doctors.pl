:- dynamic recommend_doctor/2.

% Female-Specific Conditions
recommend_doctor(pcos, gynecologist).
recommend_doctor(dysmenorrhea, gynecologist).
recommend_doctor(menopause, gynecologist).
recommend_doctor(endometriosis, gynecologist).
recommend_doctor(bacterial_vaginosis, gynecologist).
recommend_doctor(pelvic_inflammatory_disease, gynecologist).

% Male-Specific Conditions
recommend_doctor(testicular_torsion, urologist).
recommend_doctor(erectile_dysfunction, urologist).

% Infectious Diseases
recommend_doctor(german_measles, infectious_disease_specialist).
recommend_doctor(common_cold, general_physician).
recommend_doctor(measles, infectious_disease_specialist).
recommend_doctor(flu, general_physician).
recommend_doctor(mumps, ent_specialist).
recommend_doctor(chicken_pox, general_physician).
recommend_doctor(strep_throat, ent_specialist).
recommend_doctor(pneumonia, pulmonologist).
recommend_doctor(bronchitis, pulmonologist).
recommend_doctor(sinusitis, ent_specialist).
recommend_doctor(covid_19, infectious_disease_specialist).
recommend_doctor(dengue, infectious_disease_specialist).
recommend_doctor(malaria, infectious_disease_specialist).
recommend_doctor(tuberculosis, pulmonologist).

% Gastrointestinal Diseases
recommend_doctor(gastritis, gastroenterologist).
recommend_doctor(gastroenteritis, gastroenterologist).
recommend_doctor(typhoid_fever, gastroenterologist).
recommend_doctor(appendicitis, general_surgeon).

% Urinary/Kidney Diseases
recommend_doctor(urinary_tract_infection, urologist).
recommend_doctor(kidney_stones, urologist).

% Chronic Diseases
recommend_doctor(diabetes_type_2, endocrinologist).
recommend_doctor(hypertension, cardiologist).
recommend_doctor(anemia, hematologist).

% Skin Conditions
recommend_doctor(allergic_rhinitis, allergologists).
recommend_doctor(eczema, dermatologist).
recommend_doctor(psoriasis, dermatologist).

% Neurological/Mental Health
recommend_doctor(migraine, neurologist).
recommend_doctor(depression, psychiatrist).
recommend_doctor(anxiety_disorder, psychiatrist).
recommend_doctor(alzheimers_disease, neurologist).
recommend_doctor(parkinsons_disease, neurologist).

% Joint-Related Conditions
recommend_doctor(osteoarthritis, rheumatologist).
recommend_doctor(rheumatoid_arthritis, rheumatologist).
