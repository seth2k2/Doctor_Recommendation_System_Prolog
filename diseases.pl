% diseases.pl

% Disease hypotheses

% Female-specific conditions
hypothesis(Patient, pcos) :-
    patient(Patient,_,_, female,_),
    symptom(Patient, irregular_periods),
    symptom(Patient, weight_gain),
    symptom(Patient, acne),
    symptom(Patient, excessive_hair_growth).

hypothesis(Patient, dysmenorrhea) :-
    patient(Patient,_,_, female,_),
    symptom(Patient, painful_menstruation),
    symptom(Patient, lower_back_pain),
    symptom(Patient, abdominal_pain),
    symptom(Patient, nausea).

hypothesis(Patient, menopause) :-
    patient(Patient,_,_, female,_),
    symptom(Patient, irregular_periods),
    symptom(Patient, hot_flashes),
    symptom(Patient, night_sweats),
    symptom(Patient, mood_swings).

hypothesis(Patient, endometriosis) :-
    patient(Patient,_,_, female,_),
    symptom(Patient, pelvic_pain),
    symptom(Patient, painful_menstruation),
    symptom(Patient, painful_intercourse),
    symptom(Patient, infertility).

hypothesis(Patient, bacterial_vaginosis) :-
    patient(Patient,_,_, female,_),
    symptom(Patient, fishy_vaginal_odor),
    symptom(Patient, gray_discharge),
    symptom(Patient, vaginal_irritation).

hypothesis(Patient, pelvic_inflammatory_disease) :-
    patient(Patient,_,_, female,_),
    symptom(Patient, pelvic_pain),
    symptom(Patient, abnormal_discharge),
    symptom(Patient, fever),
    symptom(Patient, painful_intercourse).

% Male-specific conditions
hypothesis(Patient, testicular_torsion) :-
    patient(Patient,_,_, male,_),
    symptom(Patient, sudden_severe_testicular_pain),
    symptom(Patient, swollen_testicles),
    symptom(Patient, nausea),
    symptom(Patient, abdominal_pain).

hypothesis(Patient, erectile_dysfunction) :-
    patient(Patient,_,_, male,_),
    symptom(Patient, difficulty_achieving_erection),
    symptom(Patient, reduced_sexual_desire),
    symptom(Patient, anxiety),
    symptom(Patient, stress).

% Common infectious diseases
hypothesis(Patient, german_measles) :-
    symptom(Patient, fever),
    symptom(Patient, headache),
    symptom(Patient, runny_nose),
    symptom(Patient, rash).

hypothesis(Patient, common_cold) :-
    symptom(Patient, headache),
    symptom(Patient, sneezing),
    symptom(Patient, sore_throat),
    symptom(Patient, runny_nose),
    symptom(Patient, chills).

hypothesis(Patient, measles) :-
    symptom(Patient, cough),
    symptom(Patient, sneezing),
    symptom(Patient, runny_nose).

hypothesis(Patient, flu) :-
    symptom(Patient, fever),
    symptom(Patient, headache),
    symptom(Patient, body_ache),
    symptom(Patient, conjunctivitis),
    symptom(Patient, chills),
    symptom(Patient, sore_throat),
    symptom(Patient, runny_nose),
    symptom(Patient, cough).

hypothesis(Patient, mumps) :-
    symptom(Patient, fever),
    symptom(Patient, swollen_glands).

hypothesis(Patient, chicken_pox) :-
    symptom(Patient, fever),
    symptom(Patient, chills),
    symptom(Patient, body_ache),
    symptom(Patient, rash).

hypothesis(Patient, strep_throat) :-
    symptom(Patient, sore_throat),
    symptom(Patient, fever),
    symptom(Patient, swollen_lymph_nodes),
    symptom(Patient, headache).

hypothesis(Patient, pneumonia) :-
    symptom(Patient, cough),
    symptom(Patient, fever),
    symptom(Patient, chest_pain),
    symptom(Patient, shortness_of_breath).

hypothesis(Patient, bronchitis) :-
    symptom(Patient, cough),
    symptom(Patient, mucus_production),
    symptom(Patient, fatigue),
    symptom(Patient, chest_pain).

hypothesis(Patient, sinusitis) :-
    symptom(Patient, facial_pain),
    symptom(Patient, nasal_congestion),
    symptom(Patient, headache),
    symptom(Patient, runny_nose).

hypothesis(Patient, asthma) :-
    symptom(Patient, shortness_of_breath),
    symptom(Patient, chest_tightness),
    symptom(Patient, wheezing),
    symptom(Patient, coughing).

hypothesis(Patient, covid19) :-
    symptom(Patient, fever),
    symptom(Patient, dry_cough),
    symptom(Patient, fatigue),
    symptom(Patient, loss_of_taste_or_smell).

hypothesis(Patient, dengue) :-
    symptom(Patient, high_fever),
    symptom(Patient, headache),
    symptom(Patient, headache),
    symptom(Patient, joint_pain),
    symptom(Patient, rash).

hypothesis(Patient, malaria) :-
    symptom(Patient, fever),
    symptom(Patient, chills),
    symptom(Patient, sweating),
    symptom(Patient, headache),
    symptom(Patient, nausea).

hypothesis(Patient, tuberculosis) :-
    symptom(Patient, persistent_cough),
    symptom(Patient, weight_loss),
    symptom(Patient, night_sweats),
    symptom(Patient, fever).

% GI-related diseases
hypothesis(Patient, gastritis) :-
    symptom(Patient, abdominal_pain),
    symptom(Patient, bloating),
    symptom(Patient, nausea),
    symptom(Patient, vomiting).

hypothesis(Patient, gastroenteritis) :-
    symptom(Patient, diarrhea),
    symptom(Patient, vomiting),
    symptom(Patient, abdominal_pain),
    symptom(Patient, fever).

hypothesis(Patient, typhoid_fever) :-
    symptom(Patient, prolonged_fever),
    symptom(Patient, abdominal_pain),
    symptom(Patient, weakness),
    symptom(Patient, loss_of_appetite).

hypothesis(Patient, appendicitis) :-
    symptom(Patient, abdominal_pain),
    symptom(Patient, nausea),
    symptom(Patient, loss_of_appetite),
    symptom(Patient, fever).

% Urinary and kidney diseases
hypothesis(Patient, urinary_tract_infection) :-
    symptom(Patient, burning_sensation_during_urination),
    symptom(Patient, frequent_urination),
    symptom(Patient, cloudy_urine),
    symptom(Patient, pelvic_pain).

hypothesis(Patient, kidney_stones) :-
    symptom(Patient, severe_back_pain),
    symptom(Patient, blood_in_urine),
    symptom(Patient, nausea),
    symptom(Patient, frequent_urination).

% Chronic diseases
hypothesis(Patient, diabetes_type_2) :-
    symptom(Patient, increased_thirst),
    symptom(Patient, frequent_urination),
    symptom(Patient, fatigue),
    symptom(Patient, blurred_vision).

hypothesis(Patient, hypertension) :-
    symptom(Patient, headache),
    symptom(Patient, dizziness),
    symptom(Patient, blurred_vision),
    symptom(Patient, nosebleeds).

hypothesis(Patient, anemia) :-
    symptom(Patient, fatigue),
    symptom(Patient, pale_skin),
    symptom(Patient, shortness_of_breath),
    symptom(Patient, dizziness).

% Skin-related
hypothesis(Patient, allergic_rhinitis) :-
    symptom(Patient, sneezing),
    symptom(Patient, runny_nose),
    symptom(Patient, itchy_eyes),
    symptom(Patient, nasal_congestion).

hypothesis(Patient, eczema) :-
    symptom(Patient, dry_skin),
    symptom(Patient, itching),
    symptom(Patient, red_patches).

hypothesis(Patient, psoriasis) :-
    symptom(Patient, red_patches),
    symptom(Patient, silvery_scales),
    symptom(Patient, itching),
    symptom(Patient, joint_pain).

% Neurological and mental health
hypothesis(Patient, migraine) :-
    symptom(Patient, headache),
    symptom(Patient, nausea),
    symptom(Patient, sensitivity_to_light),
    symptom(Patient, blurred_vision).

hypothesis(Patient, depression) :-
    symptom(Patient, persistent_sadness),
    symptom(Patient, loss_of_interest),
    symptom(Patient, fatigue),
    symptom(Patient, changes_in_appetite).

hypothesis(Patient, anxiety_disorder) :-
    symptom(Patient, excessive_worry),
    symptom(Patient, restlessness),
    symptom(Patient, rapid_heartbeat),
    symptom(Patient, difficulty_concentrating).

hypothesis(Patient, alzheimers_disease) :-
    symptom(Patient, memory_loss),
    symptom(Patient, confusion),
    symptom(Patient, difficulty_completing_tasks),
    symptom(Patient, mood_changes).

hypothesis(Patient, parkinsons_disease) :-
    symptom(Patient, tremors),
    symptom(Patient, slow_movement),
    symptom(Patient, muscle_stiffness),
    symptom(Patient, balance_problems).

% Joint-related
hypothesis(Patient, osteoarthritis) :-
    symptom(Patient, joint_pain),
    symptom(Patient, stiffness),
    symptom(Patient, swelling),
    symptom(Patient, reduced_flexibility).

hypothesis(Patient, rheumatoid_arthritis) :-
    symptom(Patient, joint_pain),
    symptom(Patient, swelling),
    symptom(Patient, fatigue),
    symptom(Patient, fever).
