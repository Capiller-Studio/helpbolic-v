// obtain cookieconsent plugin
var cc = initCookieConsent();

function updatePreferences(_cookie) {
    let preferences = {
        analytics_storage: "denied",
        ad_storage: "denied",
        ad_user_data: "denied",
        ad_personalization: "denied"
    };

    if (cc.allowedCategory('analytics')) {
        preferences.analytics_storage = "granted";
    }
    if (cc.allowedCategory('advertising')) {
        preferences.ad_storage = "granted";
        preferences.ad_user_data = "granted";
        preferences.ad_personalization = "granted";
    }

    if (preferences) {
        window.dataLayer = window.dataLayer || [];

        function gtag() {
            window.dataLayer.push(arguments);
        }

        gtag("consent", "update", preferences);

        // setTimeout(function () {
        //     window.location.reload();
        // }, 1000);
    }
}

// run plugin with config object
cc.run({
    current_lang: 'en',
    autoclear_cookies: true,                    // default: false
    cookie_name: 'cookie_consent',              // default: 'cookie_consent'
    cookie_expiration: 365,                     // default: 182
    page_scripts: true,                         // default: false
    force_consent: false,                       // default: false

    // auto_language: null,                     // default: document; could also be 'browser' or 'document'
    // autorun: true,                           // default: true
    delay: 7000,                                // default: 0
    hide_from_bots: true,                       // default: false
    // remove_cookie_tables: false              // default: false
    // cookie_domain: location.hostname,        // default: current domain
    // cookie_path: '/',                        // default: root
    // cookie_same_site: 'Lax',
    // use_rfc_cookie: false,                   // default: false
    // revision: 0,                             // default: 0

    gui_options: {
        consent_modal: {
            layout: 'cloud',                    // box,cloud,bar
            position: 'bottom center',          // bottom,middle,top + left,right,center
            transition: 'slide'                 // zoom,slide
        },
        settings_modal: {
            layout: 'bar',                      // box,bar
            position: 'left',                   // right,left (available only if bar layout selected)
            transition: 'slide'                 // zoom,slide
        }
    },

    onFirstAction: ({ }) => updatePreferences(),

    onAccept: function (cookie) {
        // console.log('onAccept fired!')
    },

    // onChange: function (cookie, changed_preferences) {
    //     // console.log('onChange fired!');

    //     // If analytics category is disabled => disable google analytics
    //     if (!cc.allowedCategory('analytics')) {
    //         typeof gtag === 'function' && gtag('consent', 'update', {
    //             'analytics_storage': 'denied'
    //         });
    //     }
    // },

    // onFirstConsent: ({cookie}) => updatePreferences(cookie),
    // onFirstAction: ({cookie}) => updatePreferences(cookie),
    onChange: ({ cookie }) => updatePreferences(cookie),

    languages: {
        'en': {
            consent_modal: {
                title: 'This website uses cookies',
                description: 'We use cookies to personalize content and ads, to provide social media features and to analyze access to our website. We also share information about your use of our website with our social media, advertising and analytics partners.',
                primary_btn: {
                    text: 'Accept all',
                    role: 'accept_all'      //'accept_selected' or 'accept_all'
                },
                secondary_btn: {
                    text: 'Preferences',
                    role: 'settings'       //'settings' or 'accept_necessary'
                },
                revision_message: '<br><br> Dear user, terms and conditions have changed since the last time you visisted!'
            },
            settings_modal: {
                title: 'Cookie settings',
                save_settings_btn: 'Save current selection',
                accept_all_btn: 'Accept all',
                reject_all_btn: 'Reject all',
                close_btn_label: 'Close',
                cookie_table_headers: [
                    { col1: 'Name' },
                    { col2: 'Provider' },
                    { col3: 'Purpose' }
                ],
                blocks: [
                    {
                        title: 'Cookie usage',
                        description: `Cookies are small text files used by websites to make the user experience more efficient.
                        By law we may store cookies on your device if they are strictly necessary for the operation of this site. For all other types of cookies we need your permission.
                        This site uses different types of cookies. Some cookies are placed by third parties that appear on our sites.
                        You can change or withdraw your consent at any time from the cookie statement on our website.
                        Find out more about who we are, how you can contact us and how we process personal data in our privacy policy.
                        Please include your consent ID and date when contacting us regarding your consent.`
                    }, {
                        title: 'Strictly necessary cookies',
                        description: "Necessary cookies help make a website usable by enabling basic functions such as page navigation and access to secure areas of the website. The website cannot function properly without these cookies.",
                        toggle: {
                            value: 'necessary',
                            enabled: true,
                            readonly: true  //cookie categories with readonly=true are all treated as "necessary cookies"
                        },
                        cookie_table: [
                            {
                                col1: 'cookie_consent',
                                col2: `deskbolic.com`,
                                col3: "Stores the user's cookie consent status."
                            },
                            {
                                col1: '_deskbolic_session',
                                col2: 'deskbolic.com',
                                col3: 'Stores current session details',
                                path: '/'       // needed for autoclear cookies
                            }
                        ]
                    }, {
                        title: 'Statistics cookies',
                        description: 'Statistics cookies help website owners understand how visitors interact with websites by collecting and reporting information anonymously.',
                        toggle: {
                            value: 'analytics',
                            enabled: true,
                            readonly: false
                        },
                        cookie_table: [
                            {
                                col1: '_ga',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Registers a unique ID that is used to generate statistical data about how the visitor uses the website.',
                                is_regex: true
                            },
                            {
                                col1: '_gid',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Registers a unique ID that is used to generate statistical data about how the visitor uses the website.',
                            },
                            {
                                col1: 'td',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: '	Registers statistical data about the behavior of visitors on the website. Used by the website operator for internal analytics.',
                                path: '/'       // needed for autoclear cookies
                            },
                            {
                                col1: '_ga_#',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Collects data on how many times a user has visited a website, as well as data for the first and last visit. Used by Google Analytics.'
                            },
                            {
                                col1: '_gat',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Used by Google Analytics to limit the request rate.'
                            }
                        ]
                    }, {
                        title: 'Marketing cookies',
                        description: 'Marketing cookies are used to track visitors across websites. The intent is to show ads that are relevant and engaging to individual users and therefore more valuable to publishers and third-party advertisers.',
                        toggle: {
                            value: 'marketing',
                            enabled: true,
                            readonly: false
                        },
                        cookie_table: [
                            {
                                col1: 'pagead/landing',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Collects visitor behavior data across multiple websites to present more relevant advertising - This also allows the website to limit the number of times the same advertisement is displayed.',
                                is_regex: true
                            },
                            {
                                col1: '_gcl_au',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Used by Google AdSense to experiment with advertising effectiveness on websites that use their services.',
                            }
                        ]
                    }, {
                        title: 'Preference cookies',
                        description: 'Preference cookies allow a website to remember information that affects the way a website behaves or looks, such as: B. Your preferred language or the region you are in.',
                        toggle: {
                            value: 'preference',
                            enabled: true,
                            readonly: false
                        }
                    }, {
                        title: 'Not classified cookies',
                        description: 'Unclassified cookies are cookies that we are currently trying to classify, along with providers of individual cookies.',
                        toggle: {
                            value: 'unclassified',
                            enabled: true,
                            readonly: false
                        }
                    }, {
                        title: 'Privacy Policy',
                        description: `Thank you for visiting Techbolic Solutions (PVT) Limited. This Privacy Policy outlines how we collect, use, and protect your personal information.
                        We may collect personal information, such as your name, email address, and other details, when voluntarily provided by you.
                        We use the information you provide to deliver and improve our services, respond to inquiries, and personalize your experience on the Website.
                        We use cookies to enhance your browsing experience. You can disable cookies in your browser settings, but this may affect the functionality of the Website.
                        If you have any questions or concerns about our Privacy Policy, please contact us at info@deskbolic.com.`,
                    }
                ]
            }
        },
        'es': {
            consent_modal: {
                title: 'Este sitio web utiliza cookies',
                description: 'Utilizamos cookies para personalizar contenido y anuncios, proporcionar funciones de redes sociales y analizar el acceso a nuestro sitio web. También compartimos información sobre su uso de nuestro sitio web con nuestros socios de redes sociales, publicidad y análisis.',
                primary_btn: {
                    text: 'Aceptar todo',
                    role: 'accept_all' //'accept_selected' or 'accept_all'
                },
                secondary_btn: {
                    text: 'Preferencias',
                    role: 'settings' //'settings' or 'accept_necessary'
                },
                revision_message: '<br><br> Estimado usuario, ¡los términos y condiciones han cambiado desde la última vez que visitó!'
            },
            settings_modal: {
                title: 'Configuración de cookies',
                save_settings_btn: 'Guardar selección actual',
                accept_all_btn: 'Aceptar todo',
                reject_all_btn: 'Rechazar todo',
                close_btn_label: 'Cerrar',
                cookie_table_headers: [
                    { col1: 'Nombre' },
                    { col2: 'Proveedor' },
                    { col3: 'Propósito' }
                ],
                blocks: [
                    {
                        title: 'Uso de cookies',
                        description: `Las cookies son pequeños archivos de texto utilizados por los sitios web para hacer más eficiente la experiencia del usuario.
                                Por ley, podemos almacenar cookies en su dispositivo si son estrictamente necesarias para el funcionamiento de este sitio. Para todos los demás tipos de cookies, necesitamos su permiso.
                                Este sitio utiliza diferentes tipos de cookies. Algunas cookies son colocadas por terceros que aparecen en nuestros sitios.
                                Puede cambiar o retirar su consentimiento en cualquier momento desde la declaración de cookies en nuestro sitio web.
                                Obtenga más información sobre quiénes somos, cómo puede comunicarse con nosotros y cómo procesamos datos personales en nuestra política de privacidad.
                                Incluya su ID de consentimiento y la fecha al contactarnos sobre su consentimiento.`
                    }, {
                        title: 'Cookies estrictamente necesarias',
                        description: "Las cookies necesarias ayudan a que un sitio web sea utilizable mediante la activación de funciones básicas como la navegación por la página y el acceso a áreas seguras del sitio web. El sitio web no puede funcionar correctamente sin estas cookies.",
                        toggle: {
                            value: 'necessary',
                            enabled: true,
                            readonly: true //cookie categories with readonly=true are all treated as "necessary cookies"
                        },
                        cookie_table: [
                            {
                                col1: 'cookie_consent',
                                col2: `deskbolic.com`,
                                col3: "Almacena el estado de consentimiento de cookies del usuario."
                            },
                            {
                                col1: '_deskbolic_session',
                                col2: 'deskbolic.com',
                                col3: 'Almacena detalles de la sesión actual',
                                path: '/' // needed for autoclear cookies
                            }
                        ]
                    }, {
                        title: 'Cookies de estadísticas',
                        description: 'Las cookies de estadísticas ayudan a los propietarios de sitios web a comprender cómo interactúan los visitantes con los sitios web al recopilar y reportar información de forma anónima.',
                        toggle: {
                            value: 'analytics',
                            enabled: true,
                            readonly: false
                        },
                        cookie_table: [
                            {
                                col1: '_ga',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Registra un ID único que se utiliza para generar datos estadísticos sobre cómo el visitante utiliza el sitio web.',
                                is_regex: true
                            },
                            {
                                col1: '_gid',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Registra un ID único que se utiliza para generar datos estadísticos sobre cómo el visitante utiliza el sitio web.',
                            },
                            {
                                col1: 'td',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Registra datos estadísticos sobre el comportamiento de los visitantes en el sitio web. Utilizado por el operador del sitio web para análisis internos.',
                                path: '/' // needed for autoclear cookies
                            },
                            {
                                col1: '_ga_#',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Recoge datos sobre cuántas veces un usuario ha visitado un sitio web, así como datos de la primera y la última visita. Utilizado por Google Analytics.'
                            },
                            {
                                col1: '_gat',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Utilizado por Google Analytics para limitar la tasa de solicitudes.'
                            }
                        ]
                    }, {
                        title: 'Cookies de marketing',
                        description: 'Las cookies de marketing se utilizan para rastrear a los visitantes en los sitios web. El objetivo es mostrar anuncios que sean relevantes y atractivos para los usuarios individuales y, por lo tanto, más valiosos para los editores y anunciantes de terceros.',
                        toggle: {
                            value: 'marketing',
                            enabled: true,
                            readonly: false
                        },
                        cookie_table: [
                            {
                                col1: 'pagead/landing',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Recopila datos de comportamiento de los visitantes en varios sitios web para presentar publicidad más relevante. Esto también permite que el sitio web limite la cantidad de veces que se muestra el mismo anuncio.',
                                is_regex: true
                            },
                            {
                                col1: '_gcl_au',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Utilizado por Google AdSense para experimentar con la efectividad de la publicidad en sitios web que utilizan sus servicios.',
                            }
                        ]
                    }, {
                        title: 'Cookies de preferencias',
                        description: 'Las cookies de preferencias permiten que un sitio web recuerde información que afecta la forma en que se comporta o se ve un sitio web, como su idioma preferido o la región en la que se encuentra.',
                        toggle: {
                            value: 'preference',
                            enabled: true,
                            readonly: false
                        }
                    }, {
                        title: 'Cookies no clasificadas',
                        description: 'Las cookies no clasificadas son cookies que estamos tratando de clasificar actualmente, junto con los proveedores de cookies individuales.',
                        toggle: {
                            value: 'unclassified',
                            enabled: true,
                            readonly: false
                        }
                    }, {
                        title: 'Política de privacidad',
                        description: `Gracias por visitar Techbolic Solutions (PVT) Limited. Esta Política de Privacidad describe cómo recopilamos, utilizamos y protegemos su información personal.
                        Podemos recopilar información personal, como su nombre, dirección de correo electrónico y otros detalles, cuando usted los proporciona voluntariamente.
                        Utilizamos la información que usted proporciona para brindar y mejorar nuestros servicios, responder consultas y personalizar su experiencia en el sitio web.
                        Utilizamos cookies para mejorar su experiencia de navegación. Puede desactivar las cookies en la configuración de su navegador, pero esto puede afectar la funcionalidad del sitio web.
                        Si tiene alguna pregunta o inquietud sobre nuestra Política de Privacidad, contáctenos en info@deskbolic.com.`
                    }
                ]
            }
        },
        'fr': {
            consent_modal: {
                title: 'Ce site web utilise des cookies',
                description: 'Nous utilisons des cookies pour personnaliser le contenu et les annonces, fournir des fonctionnalités de médias sociaux et analyser l\'accès à notre site web. Nous partageons également des informations sur votre utilisation de notre site avec nos partenaires de médias sociaux, de publicité et d\'analyse.',
                primary_btn: {
                    text: 'Accepter tout',
                    role: 'accept_all' //'accept_selected' or 'accept_all'
                },
                secondary_btn: {
                    text: 'Préférences',
                    role: 'settings' //'settings' or 'accept_necessary'
                },
                revision_message: '<br><br> Cher utilisateur, les termes et conditions ont changé depuis votre dernière visite !'
            },
            settings_modal: {
                title: 'Paramètres des cookies',
                save_settings_btn: 'Enregistrer la sélection actuelle',
                accept_all_btn: 'Accepter tout',
                reject_all_btn: 'Refuser tout',
                close_btn_label: 'Fermer',
                cookie_table_headers: [
                    { col1: 'Nom' },
                    { col2: 'Fournisseur' },
                    { col3: 'Objectif' }
                ],
                blocks: [
                    {
                        title: 'Utilisation des cookies',
                        description: `Les cookies sont de petits fichiers texte utilisés par les sites web pour rendre l'expérience utilisateur plus efficace.
                        En vertu de la loi, nous pouvons stocker des cookies sur votre appareil s'ils sont strictement nécessaires au fonctionnement de ce site. Pour tous les autres types de cookies, nous avons besoin de votre permission.
                        Ce site utilise différents types de cookies. Certains cookies sont placés par des tiers qui apparaissent sur nos sites.
                        Vous pouvez changer ou retirer votre consentement à tout moment à partir de l'énoncé de cookie sur notre site web.
                        En savoir plus sur qui nous sommes, comment vous pouvez nous contacter et comment nous traitons les données personnelles dans notre politique de confidentialité.
                        Veuillez inclure votre identifiant de consentement et la date lorsque vous nous contactez concernant votre consentement.`
                    }, {
                        title: 'Cookies strictement nécessaires',
                        description: "Les cookies nécessaires contribuent à rendre un site web utilisable en activant des fonctions de base telles que la navigation dans les pages et l'accès à des zones sécurisées du site web. Le site web ne peut pas fonctionner correctement sans ces cookies.",
                        toggle: {
                            value: 'necessary',
                            enabled: true,
                            readonly: true // Les catégories de cookies avec readonly=true sont toutes traitées comme des "cookies nécessaires"
                        },
                        cookie_table: [
                            {
                                col1: 'cookie_consent',
                                col2: `deskbolic.com`,
                                col3: "Stocke l'état de consentement aux cookies de l'utilisateur."
                            },
                            {
                                col1: '_deskbolic_session',
                                col2: 'deskbolic.com',
                                col3: 'Stocke les détails de la session en cours',
                                path: '/' // nécessaire pour effacer automatiquement les cookies
                            }
                        ]
                    }, {
                        title: 'Cookies statistiques',
                        description: 'Les cookies statistiques aident les propriétaires de sites web à comprendre comment les visiteurs interagissent avec les sites web en collectant et en rapportant des informations de manière anonyme.',
                        toggle: {
                            value: 'analytics',
                            enabled: true,
                            readonly: false
                        },
                        cookie_table: [
                            {
                                col1: '_ga',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Enregistre un identifiant unique utilisé pour générer des données statistiques sur la manière dont le visiteur utilise le site web.',
                                is_regex: true
                            },
                            {
                                col1: '_gid',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Enregistre un identifiant unique utilisé pour générer des données statistiques sur la manière dont le visiteur utilise le site web.',
                            },
                            {
                                col1: 'td',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Enregistre des données statistiques sur le comportement des visiteurs sur le site web. Utilisé par l\'opérateur du site web pour l\'analyse interne.',
                                path: '/' // nécessaire pour effacer automatiquement les cookies
                            },
                            {
                                col1: '_ga_#',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Collecte des données sur le nombre de fois quun utilisateur a visité un site web, ainsi que des données pour la première et la dernière visite. Utilisé par Google Analytics.'
                            },
                            {
                                col1: '_gat',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Utilisé par Google Analytics pour limiter le taux de requêtes.'
                            }
                        ]
                    }, {
                        title: 'Cookies marketing',
                        description: 'Les cookies marketing sont utilisés pour suivre les visiteurs à travers les sites web. L\'objectif est de diffuser des annonces pertinentes et attrayantes pour les utilisateurs individuels et donc plus précieuses pour les éditeurs et les annonceurs tiers.',
                        toggle: {
                            value: 'marketing',
                            enabled: true,
                            readonly: false
                        },
                        cookie_table: [
                            {
                                col1: 'pagead/landing',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Collecte des données comportementales des visiteurs sur plusieurs sites web pour présenter une publicité plus pertinente - Cela permet également au site web de limiter le nombre de fois où la même annonce est affichée.',
                                is_regex: true
                            },
                            {
                                col1: '_gcl_au',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Utilisé par Google AdSense pour expérimenter l\'efficacité de la publicité sur les sites web qui utilisent leurs services.',
                            }
                        ]
                    }, {
                        title: 'Cookies de préférence',
                        description: 'Les cookies de préférence permettent à un site web de se souvenir des informations qui affectent la manière dont un site web se comporte ou apparaît, telles que votre langue préférée ou la région dans laquelle vous vous trouvez.',
                        toggle: {
                            value: 'preference',
                            enabled: true,
                            readonly: false
                        }
                    }, {
                        title: 'Cookies non classés',
                        description: 'Les cookies non classés sont des cookies que nous essayons actuellement de classer, avec les fournisseurs de cookies individuels.',
                        toggle: {
                            value: 'unclassified',
                            enabled: true,
                            readonly: false
                        }
                    }, {
                        title: 'Politique de confidentialité',
                        description: `Merci d'avoir visité Techbolic Solutions (PVT) Limited. Cette politique de confidentialité décrit la manière dont nous collectons, utilisons et protégeons vos informations personnelles.
                        Nous pouvons collecter des informations personnelles, telles que votre nom, votre adresse e-mail et d'autres détails, lorsque vous les fournissez volontairement.
                        Nous utilisons les informations que vous fournissez pour fournir et améliorer nos services, répondre aux demandes de renseignements et personnaliser votre expérience sur le site Web.
                        Nous utilisons des cookies pour améliorer votre expérience de navigation. Vous pouvez désactiver les cookies dans les paramètres de votre navigateur, mais cela peut affecter la fonctionnalité du site Web.
                        Si vous avez des questions ou des préoccupations concernant notre politique de confidentialité, veuillez nous contacter à info@deskbolic.com.`
                    }
                ]
            }
        },
        'de': {
            consent_modal: {
                title: 'Diese Website verwendet Cookies',
                description: 'Wir verwenden Cookies, um Inhalte und Anzeigen zu personalisieren, Funktionen für soziale Medien bereitzustellen und den Zugriff auf unsere Website zu analysieren. Wir teilen auch Informationen über Ihre Nutzung unserer Website mit unseren Partnern für soziale Medien, Werbung und Analyse.',
                primary_btn: {
                    text: 'Alle akzeptieren',
                    role: 'accept_all' //'accept_selected' or 'accept_all'
                },
                secondary_btn: {
                    text: 'Einstellungen',
                    role: 'settings' //'settings' or 'accept_necessary'
                },
                revision_message: '<br><br> Lieber Benutzer, die Geschäftsbedingungen haben sich seit Ihrem letzten Besuch geändert!'
            },
            settings_modal: {
                title: 'Cookie-Einstellungen',
                save_settings_btn: 'Aktuelle Auswahl speichern',
                accept_all_btn: 'Alle akzeptieren',
                reject_all_btn: 'Alle ablehnen',
                close_btn_label: 'Schließen',
                cookie_table_headers: [
                    { col1: 'Name' },
                    { col2: 'Anbieter' },
                    { col3: 'Zweck' }
                ],
                blocks: [
                    {
                        title: 'Cookie-Nutzung',
                        description: `Cookies sind kleine Textdateien, die von Websites verwendet werden, um die Benutzererfahrung effizienter zu gestalten.
                            Nach dem Gesetz dürfen wir Cookies auf Ihrem Gerät speichern, wenn sie für den Betrieb dieser Website unbedingt erforderlich sind. Für alle anderen Arten von Cookies benötigen wir Ihre Zustimmung.
                            Diese Website verwendet verschiedene Arten von Cookies. Einige Cookies werden von Dritten platziert, die auf unseren Websites erscheinen.
                            Sie können Ihre Zustimmung jederzeit über die Cookie-Erklärung auf unserer Website ändern oder zurückziehen.
                            Erfahren Sie mehr darüber, wer wir sind, wie Sie uns kontaktieren können und wie wir personenbezogene Daten in unserer Datenschutzrichtlinie verarbeiten.
                            Bitte geben Sie bei Anfragen zu Ihrer Zustimmung Ihre Zustimmungs-ID und das Datum an.`
                    }, {
                        title: 'Unbedingt notwendige Cookies',
                        description: "Notwendige Cookies tragen dazu bei, eine Website nutzbar zu machen, indem sie Grundfunktionen wie Seitennavigation und den Zugriff auf sichere Bereiche der Website ermöglichen. Die Website kann ohne diese Cookies nicht ordnungsgemäß funktionieren.",
                        toggle: {
                            value: 'necessary',
                            enabled: true,
                            readonly: true //Cookie-Kategorien mit readonly=true gelten alle als "notwendige Cookies"
                        },
                        cookie_table: [
                            {
                                col1: 'cookie_consent',
                                col2: `deskbolic.com`,
                                col3: 'Speichert den Zustimmungsstatus des Benutzers zu Cookies.'
                            },
                            {
                                col1: '_deskbolic_session',
                                col2: 'deskbolic.com',
                                col3: 'Speichert aktuelle Sitzungsdetails',
                                path: '/' // benötigt für das automatische Löschen von Cookies
                            }
                        ]
                    }, {
                        title: 'Statistik-Cookies',
                        description: 'Statistik-Cookies helfen Website-Besitzern zu verstehen, wie Besucher mit Websites interagieren, indem sie Informationen anonym sammeln und melden.',
                        toggle: {
                            value: 'analytics',
                            enabled: true,
                            readonly: false
                        },
                        cookie_table: [
                            {
                                col1: '_ga',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Registriert eine eindeutige ID, die zur Erzeugung statistischer Daten darüber verwendet wird, wie der Besucher die Website nutzt.',
                                is_regex: true
                            },
                            {
                                col1: '_gid',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Registriert eine eindeutige ID, die zur Erzeugung statistischer Daten darüber verwendet wird, wie der Besucher die Website nutzt.',
                            },
                            {
                                col1: 'td',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Registriert statistische Daten zum Verhalten von Besuchern auf der Website. Wird vom Website-Betreiber für interne Analysen verwendet.',
                                path: '/' // benötigt für das automatische Löschen von Cookies
                            },
                            {
                                col1: '_ga_#',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Sammelt Daten darüber, wie oft ein Benutzer eine Website besucht hat, sowie Daten für den ersten und letzten Besuch. Wird von Google Analytics verwendet.'
                            },
                            {
                                col1: '_gat',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Wird von Google Analytics verwendet, um die Anfragerate zu begrenzen.'
                            }
                        ]
                    }, {
                        title: 'Marketing-Cookies',
                        description: 'Marketing-Cookies werden verwendet, um Besucher über Websites hinweg zu verfolgen. Die Absicht besteht darin, Anzeigen anzuzeigen, die für einzelne Benutzer relevant und ansprechend sind und daher für Herausgeber und Drittanbieter-Werbetreibende wertvoller sind.',
                        toggle: {
                            value: 'marketing',
                            enabled: true,
                            readonly: false
                        },
                        cookie_table: [
                            {
                                col1: 'pagead/landing',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Sammelt Verhaltensdaten von Besuchern über mehrere Websites, um relevantere Werbung anzuzeigen. Dies ermöglicht es der Website auch, die Anzahl der Anzeigenanzeigungen zu begrenzen.',
                                is_regex: true
                            },
                            {
                                col1: '_gcl_au',
                                col2: `<a href="https://google.com">Google</a>`,
                                col3: 'Wird von Google AdSense verwendet, um die Wirksamkeit von Werbung auf Websites zu testen, die ihre Dienste nutzen.',
                            }
                        ]
                    }, {
                        title: 'Präferenz-Cookies',
                        description: 'Präferenz-Cookies ermöglichen einer Website das Speichern von Informationen, die sich auf das Verhalten oder das Aussehen einer Website auswirken, wie z. B. Ihre bevorzugte Sprache oder die Region, in der Sie sich befinden.',
                        toggle: {
                            value: 'preference',
                            enabled: true,
                            readonly: false
                        }
                    }, {
                        title: 'Nicht klassifizierte Cookies',
                        description: 'Nicht klassifizierte Cookies sind Cookies, die wir derzeit zu klassifizieren versuchen, zusammen mit Anbietern einzelner Cookies.',
                        toggle: {
                            value: 'unclassified',
                            enabled: true,
                            readonly: false
                        }
                    }, {
                        title: 'Datenschutzrichtlinie',
                        description: `Vielen Dank für Ihren Besuch bei Techbolic Solutions (PVT) Limited. Diese Datenschutzrichtlinie beschreibt, wie wir Ihre persönlichen Daten sammeln, verwenden und schützen.
                        Wir können personenbezogene Daten wie Ihren Namen, Ihre E-Mail-Adresse und andere Daten erfassen, wenn Sie uns diese freiwillig zur Verfügung stellen.
                        Wir verwenden die von Ihnen bereitgestellten Informationen, um unsere Dienste bereitzustellen und zu verbessern, auf Anfragen zu antworten und Ihr Erlebnis auf der Website zu personalisieren.
                        Wir verwenden Cookies, um Ihr Surferlebnis zu verbessern. Sie können Cookies in Ihren Browsereinstellungen deaktivieren, dies kann jedoch die Funktionalität der Website beeinträchtigen.
                        Wenn Sie Fragen oder Bedenken zu unserer Datenschutzrichtlinie haben, kontaktieren Sie uns bitte unter info@deskbolic.com.`
                    }
                ]
            }
        }
    }
});