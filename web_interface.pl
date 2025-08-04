:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/html_write)).

:- [channel].
:- [diseases].
:- [recommend_doctors].
:- [doctors].
:- [user_data].

:- dynamic patient/5.
:- dynamic channel/2.
:- dynamic user_symptoms/2.
:- dynamic probable_user_disease/2.
:- discontiguous diagnosis_page/1.
:- discontiguous patient/5.

:- http_handler(root(.), login_page, []).
:- http_handler(root(login), login_page, []).
:- http_handler(root(register), register_page, []).
:- http_handler(root(diagnose), diagnosis_page, []).
:- http_handler(root(doctor_details), doctor_details_page, []).
:- http_handler(root(channel), channel_handler, []).
:- http_handler(root(channels), user_channels_page, []).
:- http_handler(root(delete_channel), delete_channel_handler, []).
:- http_handler(root(manual_channeling), manual_channeling_page, []).
:- http_handler(root(debug_channels), debug_channels_page, []).

start_server(Port) :-
    http_server(http_dispatch, [port(Port)]).

register_page(Request) :-
    member(method(post), Request), !,
    http_parameters(Request, [
        username(Username, [default("")]),
        name(Name, [default("")]),
        gender(Gender, [default("")]),
        age(Age, [integer, default(0)]),
        password(Password, [default("")])
    ]),
    (
      (Username = "" ; Name = "" ; Gender = "" ; Age = 0 ; Password = "") ->
         reply_html_page(title('Register'), [
           \alert_script('Please fill in all fields!'),
           \register_form
         ])

      ; patient(Username, _, _, _, _) ->
         reply_html_page(title('Register'), [
           \alert_script('Username already exists! Choose another.'),
           \register_form
         ])

      ; assertz(patient(Username, Password, Name, Gender, Age)),
        save_user_fact(patient(Username, Password, Name, Gender, Age)),
        reply_html_page(title('Registered'), [
          \alert_script('Registration successful!'),
          \login_form  
        ])
    ).

register_page(_Request) :-
    reply_html_page(title('Register'), [
      \register_form
    ]).

register_form -->
    html([
      h1([style('text-align: center; color: #2c3e50; margin-bottom: 1rem;')], 'Register'),
      form([action('/register'), method('POST'),
            style('margin: 0 auto; max-width: 400px; background: #fff; padding: 30px; border: 2px solid #ddd; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);')],
      [
        p(['Username: ',
          input([name(username),
                 style('width: 100%; padding: 8px; margin-top: 5px; border: 1px solid #ddd; border-radius: 4px;')])]),
        p(['Name: ',
          input([name(name),
                 style('width: 100%; padding: 8px; margin-top: 5px; border: 1px solid #ddd; border-radius: 4px;')])]),
        p(['Gender: ',
          input([name(gender),
                 style('width: 100%; padding: 8px; margin-top: 5px; border: 1px solid #ddd; border-radius: 4px;')])]),
        p(['Age: ',
          input([name(age), type(number),
                 style('width: 100%; padding: 8px; margin-top: 5px; border: 1px solid #ddd; border-radius: 4px;')])]),
        p(['Password: ',
          input([name(password), type(password),
                 style('width: 100%; padding: 8px; margin-top: 5px; border: 1px solid #ddd; border-radius: 4px;')])]),
        p([style('text-align: center; margin-top: 20px;')],
          input([type(submit), value('Register'),
                 style('background: #2196f3; color: #fff; border: none; border-radius: 4px; padding: 10px 20px; cursor: pointer; font-size: 1rem;')]))
      ])
    ]).


% === Login Page ===
login_page(Request) :-
    member(method(post), Request), !,
    http_parameters(Request, [
        username(Username, [default("")]),
        password(Password, [default("")])
    ]),
    (
      (Username = "" ; Password = "") ->
         reply_html_page(title('Login'), [
           \alert_script('Please enter both username and password!'),
           \login_form  
         ])
      ; patient(Username, Password, _, _, _) ->
         reply_html_page(title('Welcome'), [
           \logged_in_header(Username),
           h1(['Hello ', Username, ' !']),
           div([style('text-align: center; font-weight: bold; font-size: 1.7rem; color: #003366; margin-top: 4%;')], [
               p('Welcome to our Symptom-Based Diagnosis platform!'),
               p('This website is designed to help users identify potential diseases based on their symptoms.'),
               p('Powered by HTML, CSS, and Prolog, our platform offers an intuitive way to input and evaluate symptoms.'),
               p('Once a potential disease is identified, we also recommend a suitable specialist for further consultation.'),
               p('Our goal is to provide a comprehensive tool to help you better understand and manage your health.')
           ]),
           p(a(href('/diagnose?user=' + Username), ''))
         ])
      ; reply_html_page(title('Login'), [
           \alert_script('Invalid username or password!'),
           \login_form  % Renders the same login form again
        ])
    ).

login_page(_Request) :-
    reply_html_page(title('Login'), [
      \login_form
    ]).

login_form -->
    html([
      h1([style('text-align: center; color: #2c3e50; margin-bottom: 1rem;')], 'Login'),
      form([action('/login'), method('POST'),
            style('margin: 0 auto; max-width: 400px; background: #fff; padding: 30px; border: 2px solid #ddd; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);')],
      [
        p(['Username: ',
          input([name(username),
                 style('width: 100%; padding: 8px; margin-top: 5px; border: 1px solid #ddd; border-radius: 4px;')])]),
        p(['Password: ',
          input([name(password), type(password),
                 style('width: 100%; padding: 8px; margin-top: 5px; border: 1px solid #ddd; border-radius: 4px;')])]),
        p([style('text-align: center; margin-top: 20px;')], [
          input([type(submit),
                 value('Login'),
                 style('background: #2196f3; color: #fff; border: none; border-radius: 4px; padding: 10px 20px; cursor: pointer; font-size: 1rem;')]),
          a([href('/register'),
             style('font-family: "Segoe UI", Arial, sans-serif; margin-left: 10px; text-decoration: none; background: #2196f3; color: #fff; display: inline-block; padding: 8px 18px; border-radius: 4px; font-size: 1rem;')],
            'Register')
        ])
      ])
    ]).

alert_script(Message) -->
    html(script(type('text/javascript'), [
        'alert("', Message, '");'
    ])).

% === Diagnosis Page ===
diagnosis_page(Request) :-
    member(method(post), Request), !,
    http_parameters(Request, [
        user(User, []),
        symptoms(SymptomList, [optional(true), list(atom)])
    ]),
    retractall(user_symptoms(User, _)),
    retractall(probable_user_disease(User, _)),
    delete_user_facts(User),

    % Save new symptoms
    forall(member(Symptom, SymptomList), (
        assertz(user_symptoms(User, Symptom)),
        save_user_fact(user_symptoms(User, Symptom))
    )),
(hypothesis(User, Disease) ->
    save_user_fact(probable_user_disease(User, Disease)),
    (recommend_doctor(Disease, Spec) ->
        findall(Doc, doctor(Doc, Spec,_), Docs),

        render_doctor_block(User, Docs, DocHTML),
        reply_html_page(title('Diagnosis Result'),
            [\logged_in_header(User),
                 div(style('text-align: center; color: #2c3e50; font-size: 1.5rem;'),
                     [ h2('Diagnosis Result'),
                       p([User, ' you have symptoms of ',span(style('color: red;'), Disease)]),
                       p(['Recommended specialist: ', span(style('color: red;'), Spec)])
                     ])
            | DocHTML ])
    ;
        findall(Doc, doctor(Doc, general_physician,_), GPDocs),
        render_doctor_block(User, GPDocs, GPHTML),
        reply_html_page(title('Diagnosis Result'),
            [ \logged_in_header(User),
              div(style('text-align: center; color: #2c3e50; font-size: 1.5rem;'),
                  [ h2('Diagnosis Result'),
                    p([User, ' you have symptoms of ', Disease, '.']),
                    p('Please consult a general physician.')
                  ])
            | GPHTML ])
    )
;
    findall(Doc, doctor(Doc, general_physician,_), GPDocs),
    render_doctor_block(User, GPDocs, GPHTML),
    reply_html_page(title('Diagnosis Failed'),
        [ \logged_in_header(User),
          div(style('text-align: center; color: #2c3e50; font-size: 1.5rem;'),
              [ h2('No Disease Identified'),
                p('Unable to determine disease. Consider seeing a general physician.')
              ])
        | GPHTML ])
).

symptom(Patient, Symptom) :- 
    user_symptoms(Patient, Symptom).

diagnosis_page(Request) :-
    http_parameters(Request, [user(User, [])]),
    findall(Symptom,
        (clause(hypothesis(_, _), Body),
         sub_term(symptom(_, SymptomAtom), Body),
         atom(SymptomAtom), Symptom = SymptomAtom),
    SymptomsDup),
    list_to_set(SymptomsDup, Symptoms),
    length(Symptoms, Len),
    Q1 is Len // 4,
    length(C1, Q1), append(C1, R1, Symptoms),
    length(C2, Q1), append(C2, R2, R1),
    length(C3, Q1), append(C3, C4, R2),

    reply_html_page(title('Enter Symptoms'),
        [ \logged_in_header(User),
          div([style('text-align: center;')], h2('Symptom-Based Diagnosis')),
          div([style('display: flex; justify-content: center;')], [
            form([action('/diagnose'), method('POST')], [
              input([type(hidden), name(user), value(User)]),
              div([class('symptom-list')], [
                ul([], \checkbox_list(C1)),
                ul([], \checkbox_list(C2)),
                ul([], \checkbox_list(C3)),
                ul([], \checkbox_list(C4))
              ]),
              div([style('text-align: center; margin-top: 20px;')], [
                p([input([type(submit), value('Submit'),
                          style('background-color: #2196f3; border: 1px solid #2196f3; color: white; padding: 10px 20px; border-radius: 5px; font-size: 1.1rem; cursor: pointer;')]),
                   \clear_checkbox_button]),
                h3([style('margin-top: 15px;')], 'Check your symptoms if they\'re available or else keep them empty, and click submit.')
              ])
            ])
          ]),
        style([
            '.symptom-list {',
            '    display: grid;',
            '    grid-template-columns: repeat(4, 1fr);',
            '    gap: 20px;',
            '}',
            '@media (max-width: 1000px) {',
            '    .symptom-list {',
            '        grid-template-columns: repeat(3, 1fr);',
            '    }',
            '}',
            '@media (max-width: 800px) {',
            '    .symptom-list {',
            '        grid-template-columns: repeat(2, 1fr);',
            '        justify-content: space-between;',
            '        column-gap: 40px;', 
            '    }',
            '}',
            '@media (max-width: 550px) {',
            '    .symptom-list {',
            '        grid-template-columns: 1fr;',
            '        justify-content: center;',
            '        margin-left: 20%;',
            '    }',
            '}',
            '.symptom-list ul {',
            '    list-style-type: none;',
            '    padding-left: 0;',
            '    color: #2c3e50;',
            '    font-size: 1.1rem;',
            '}'
        ])
        ]).

render_doctor_block(_, [], [p(style('text-align: center; color: #2c3e50; font-size: 1.5rem;'), 'No doctors available.')]).
render_doctor_block(User, Docs, 
    [p(style('text-align: center; color: #1a237e; font-weight: bold; font-size: 1.5rem;'), 'Available doctors:'), 
     ul(style('text-align: center; color: #2c3e50; font-size: 1.5rem; list-style-position: inside; padding: 0;list-style-type: none;'), 
        \doc_list(User, Docs))]).

doc_list(_, []) --> [].
doc_list(User, [Name|T]) -->
    {
        format(atom(Link), '/doctor_details?name=~w&user=~w', [Name, User])
    },
    html([li(a(href(Link), Name))]),
    doc_list(User, T).



% === Doctor Details Page ===

doctor_details_page(Request) :-
    http_parameters(Request, [
        name(Name, []),
        user(User, [])  % Get the user from the URL parameters
    ]),
    (doctor(Name, Spec, Description) ->
        reply_html_page(title('Doctor Details'),
            [\logged_in_header(User),
             div([style('text-align: center;')], [
                h2([style('font-size: 2rem; color: darkblue; font-weight: bold;')], Name),
                p([style('margin-top:3%;font-size: 1.5rem; color:  #2c3e50;')], ['Specialization: ', Spec]),
                p([style('font-size: 1.5rem; color:  #2c3e50; margin-bottom:3%;')], Description),
                form([action('/channel'), method('POST')], [
                    input([type(hidden), name(doctor), value(Name)]),
                    input([type(hidden), name(user), value(User)]),
                    input([type(submit), value('Channel Now'),
                           style('background-color: #2196f3; border: 1px solid #2196f3; color: white; padding: 10px 20px; border-radius: 5px; font-size: 1.1rem; cursor: pointer;')])
                ])
             ])
            ])
    ;
        reply_html_page(title('Not Found'), [h2('Doctor not found.')])
    ).


channel_handler(Request) :-
    member(method(post), Request), !,
    http_parameters(Request, [
        user(User, []),
        doctor(Doctor, [])
    ]),
    (channel(User, Doctor) ->
        format(atom(RedirectURL), '/doctor_details?name=~w&user=~w', [Doctor, User]),
        reply_html_page(title('Already Channeled'), [
            \logged_in_header(User),
            \redirect_with_alert('You have already channeled this doctor.', RedirectURL)
        ])
    ;
        
        retractall(channel(User, Doctor)),
        assertz(channel(User, Doctor)),
        save_channels,
        format(atom(RedirectURL), '/doctor_details?name=~w&user=~w', [Doctor, User]),
        reply_html_page(title('Channel Success'), [
            \logged_in_header(User),
            \redirect_with_alert('Successfully channeled the doctor.', RedirectURL)
        ])
    ).

% Update save_channels predicate
save_channels :-
    absolute_file_name('channel.pl', AbsPath),
    open(AbsPath, write, Stream),
    write(Stream, ':- dynamic channel/2.\n\n'),
    findall(channel(U,D), channel(U,D), Channels),
    forall(member(Channel, Channels),(writeq(Stream, Channel), write(Stream, '.\n'))),
    close(Stream),
    retractall(channel(_, _)),
    consult('channel.pl').


user_channels_page(Request) :-
    http_parameters(Request, [user(User, [])]),
    findall(Doctor, channel(User, Doctor), DoctorList),
    maplist(channel_row(User), DoctorList, Rows),
    reply_html_page(title('Your Channels'),
    [ \logged_in_header(User),
      h2([style('margin-bottom: 3%;')], 'Your Channel List') | Rows
    ]).

channel_row(User, Doctor, HtmlRow) :-
    HtmlRow = div([class(channel_row),style('display: flex; justify-content: space-between; align-items: center;')], [
        span([class(doctor_name), style('margin: 0;font-size: 1.5rem; font-weight: bold;')], Doctor),
        form([method(get), action('/delete_channel'), style('display: inline-block; margin: 0; float: right;')], [
            input([type(hidden), name(user), value(User)]),
            input([type(hidden), name(doctor), value(Doctor)]),
            input([type(submit), value('Delete Channel'),
                   class(delete_btn),
                   style('display: inline-block; background-color: red; color: white; border: none;font-size: 1.1rem; padding: 5px 10px; cursor: pointer; border-radius: 5px;'),
                   onclick('return confirm("Are you sure you want to delete this channel?");')])
        ])
    ]).


delete_channel_handler(Request) :-
    http_parameters(Request, [
        user(User, []),
        doctor(Doctor, [])
    ]),
    retractall(channel(User, Doctor)),

    absolute_file_name('channel.pl', AbsPath),
    open(AbsPath, write, Stream),
    write(Stream, ':- dynamic channel/2.\n\n'),
    findall(channel(U,D), channel(U,D), Channels),
    forall(member(Channel, Channels),
           (writeq(Stream, Channel), write(Stream, '.\n'))),
    close(Stream),
    retractall(channel(_, _)),
    consult('channel.pl'),
    format(atom(RedirectURL), '/channels?user=~w', [User]),
    http_redirect(see_other, RedirectURL, _).


manual_channeling_page(Request) :-
    http_parameters(Request, [user(User, [])]),
    findall(Spec, doctor(_, Spec, _), SpecsDup),
    sort(SpecsDup, Specs),
    maplist(spec_section(User), Specs, Sections),
    reply_html_page(title('Manual Channeling'), [
        \logged_in_header(User),
        h2('Doctors by Specialization'),
        div([class('specializations-container')], Sections),
        style([
            '.specializations-container {',
            '    display: flex;',
            '    flex-wrap: wrap;',
            '    justify-content: space-between;',
            '    gap: 20px;',
            '    margin-top: 20px;',
            '}',
            '',
            '.specialization {',
            '    width: 20%;', 
            '    box-sizing: border-box;',
            '    margin-bottom: 3%;',
            '}',
            '',
            '.specialization h3 {',
            '    text-align: center;',
            '    font-size: 1.5rem;',
            '    color: darkblue;',
            '    font-weight: bold;',
            '}',
            '',
            '.specialization ul {',
            '    list-style-type: none;',
            '    padding-left: 0;',
            '    text-align: center;',
            '}',
            '',
            '.specialization li {',
            '    margin-bottom: 10px;',
            '}',
            '',
            '@media (max-width: 1200px) {',
            '    .specialization {',
            '        width: 30%;', 
            '    }',
            '    .specialization h3 {',
            '        font-size: 1.3rem;',
            '    }',
            '}',
            '',
            '@media (max-width: 800px) {', 
            '    .specialization {',
            '        width: 35%;', 
            '    }',
            '  .specialization h3 {',
            '        font-size: 1.3rem;',
            '    }',
            '',
            '@media (max-width: 500px) {',
            '    .specialization {',
            '        width: 100%;', 
            '    }',
            '    .specialization h3 {',
            '        font-size: 1.3rem;', 
            '    }',
            '    .specializations-container {',
            '        display: flex;',
            '        flex-direction: column;',  
            '        align-items: center;', 
            '        width: 100%;', 
            '        margin: 0 auto;',
            '    }',
            '}'

        ])
    ]).

spec_section(User, Spec, Html) :-
    findall(Name, doctor(Name, Spec, _), Names),
    maplist(make_doc_link(User), Names, Links),
    Html = div([class('specialization')], [
        h3(Spec),
        ul(Links)
    ]).

make_doc_link(User, Name, li(a(href(Link), Name))) :-
    format(atom(Link), '/doctor_details?name=~w&user=~w', [Name, User]).


% === Header for logged-in users ===

logged_in_header(User) -->
    {
        patient(User, Password, _, _, _), 
        format(atom(DiagLink), '/diagnose?user=~w', [User]),
        format(atom(ManualLink), '/manual_channeling?user=~w', [User]),
        format(atom(ChannelLink), '/channels?user=~w', [User])
    },
    html([
        style(
        ['
            /* Global Styles */
            body { 
                font-family: "Segoe UI", Arial, sans-serif;
                line-height: 1.6;
                margin: 0;
                padding: 20px;
                background-color: #f5f5f5;
            }
            h1, h2, h3 { 
                color: #2c3e50;
                margin-bottom: 1rem;
                text-align: center; /* Center headings */
            }

            /* Navigation Styles */
            nav {
                background: #fff;
                padding: 15px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin-bottom: 30px;
                display: flex;
                align-items: center;
                gap: 15px;
            }
            nav a.logout-btn {
                margin-left: auto; /* Place logout on the far right */
            }
            /* Light blue buttons with white text */
            nav a, nav button, nav input[type="submit"] {
                text-decoration: none;
                color: #ffffff;
                padding: 8px 16px;
                border-radius: 4px;
                transition: all 0.3s ease;
                border: 1px solid #2196f3;
                background: #2196f3;
                cursor: pointer;
            }
            nav a:hover, nav button:hover, nav input[type="submit"]:hover {
                background: #1976d2;
                border-color: #1976d2;
            }

            /* Automatic Diagnosis Page: make submit & clear same size and gap */
            form[action="/diagnose"] p input[type="submit"],
            form[action="/diagnose"] p button {
                min-width: 120px;
                margin-right: 15px;
            }

            /* Channel List: narrower width, spaced button */
            .channel_row {
                max-width: 600px;  
                margin: 10px auto; 
                background: white;
                padding: 15px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                display: flex;
                align-items: center;
                gap: 15px;  
                justify-content: flex-start;
            }

            /* Manual Channeling: 3 specializations per line */
            .manual-channeling-page {
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
                gap: 20px;
                margin-top: 20px;
            }
            /* Each specialization block: 3 columns in a row, then new line */
            .manual-channeling-page > div {
                width: 28%;
                min-width: 200px;
                box-sizing: border-box;
            }

            /* Basic Responsiveness for mobile */
            @media (max-width: 768px) {
                nav {
                    flex-direction: column;
                }
                .manual-channeling-page > div {
                    width: 45%; /* 2 columns on medium screens */
                }
                 nav a.logout-btn {
                margin-left: 0; /* Place logout on the far right */
                }
            }
            @media (max-width: 480px) {
                .manual-channeling-page > div {
                    width: 90%; /* 1 column on small screens */
                }
                nav a.logout-btn {
                margin-left: 0; /* Place logout on the far right */
                }
            }
        ']),
        nav([class('nav-container')], [
            % Existing form for Home button
            form([action('/login'), method('POST')], [
                input([type(hidden), name(username), value(User)]),
                input([type(hidden), name(password), value(Password)]),
                input([type(submit), value('Home'), class('nav-btn'),
                    style('padding: 12px 22px; font-size: 1rem;')])
            ]),
            a([href(DiagLink), class('nav-btn')], 'Automatic Diagnosis'),
            a([href(ManualLink), class('nav-btn')], 'Manual Channeling'),
            a([href(ChannelLink), class('nav-btn')], 'My Channels'),
            a([href('/login'), class('logout-btn')], 'Logout')
        ])
    ]).

redirect_with_alert(Message, URL) -->
    html(script(type('text/javascript'), [
        'alert("', Message, '");',
        'window.location.href = "', URL, '";'
    ])).


checkbox_list([]) --> [].
checkbox_list([Symptom | Rest]) -->
    {
        atom_string(Symptom, Label)
    },
    html(li([
        label([], [
            input([type(checkbox), name(symptoms), value(Label)]),
            Label
        ])
    ])),
    checkbox_list(Rest).

clear_checkbox_button -->
    html(button([type(button), style('margin-left:10%;background-color: #2196f3; border: 1px solid #2196f3; color: white; padding: 10px 20px; border-radius: 5px; font-size: 1.1rem; cursor: pointer;'),
                 onclick('document.querySelectorAll("input[type=checkbox]").forEach(cb => cb.checked = false);')],
                'Clear')).


% Save user facts permanently with absolute path
save_user_fact(Fact) :-
    absolute_file_name('user_data.pl', AbsPath),  % Get the absolute path of the file
    open(AbsPath, append, Stream),
    writeq(Stream, Fact), write(Stream, '.'), nl(Stream),
    close(Stream).

% Delete specific facts from user_data.pl
delete_user_facts(Patient) :-
    % Step 1: Read all facts from the file
    read_all_facts(Facts),
    
    % Step 2: Filter out the ones to delete
    exclude(should_delete(Patient), Facts, NewFacts),
    
    % Step 3: Rewrite the file without the deleted facts
    absolute_file_name('user_data.pl', AbsPath),  % Get the absolute path of the file
    open(AbsPath, write, Stream),
    write_facts(NewFacts, Stream),
    close(Stream).

% Read all facts from the file
read_all_facts(Facts) :-
    absolute_file_name('user_data.pl', AbsPath),  % Get the absolute path of the file
    open(AbsPath, read, Stream),
    read_all(Stream, Facts),
    close(Stream).

read_all(Stream, []) :-
    at_end_of_stream(Stream), !.
read_all(Stream, Rest) :-
    read(Stream, Term),
    ( Term == end_of_file ->
        Rest = []
    ;
        Rest = [Term | More],
        read_all(Stream, More)
    ).

% Helper predicate to identify facts to delete
should_delete(Patient, Fact) :-
    functor(Fact, user_symptoms, 2),
    arg(1, Fact, Patient).

should_delete(Patient, Fact) :-
    functor(Fact, probable_user_disease, 2),
    arg(1, Fact, Patient).

% Write facts back to file
write_facts([], _).
write_facts([Fact|Rest], Stream) :-
    writeq(Stream, Fact),
    write(Stream, '.'), nl(Stream),
    write_facts(Rest, Stream).


:- initialization(start).

start :- 
    Port = 8080, 
    format('Starting server on port ~w...~n', [Port]),
    start_server(Port).