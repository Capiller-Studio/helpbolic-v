// Obtain cookieconsent plugin
var cc = initCookieConsent();
window.cc = cc;

function updatePreferences() {
    let preferences = {
        analytics_storage: "denied",
        ad_storage: "denied",
        ad_user_data: "denied",
        ad_personalization: "denied"
    };

    if (cc.allowedCategory('analytics')) {
        preferences.analytics_storage = "granted";
    }
    if (cc.allowedCategory('marketing') || cc.allowedCategory('advertising')) {
        preferences.ad_storage = "granted";
        preferences.ad_user_data = "granted";
        preferences.ad_personalization = "granted";
    }

    window.dataLayer = window.dataLayer || [];

    function gtag() {
        window.dataLayer.push(arguments);
    }

    gtag("consent", "update", preferences);
}

cc.run({
    current_lang: 'en',
    auto_language: 'document',
    autoclear_cookies: true,
    cookie_name: 'cookie_consent',
    cookie_expiration: 365,
    page_scripts: true,
    force_consent: false,
    delay: 1200,
    hide_from_bots: true,

    gui_options: {
        consent_modal: {
            layout: 'cloud',
            position: 'bottom center',
            transition: 'slide'
        },
        settings_modal: {
            layout: 'bar',
            position: 'left',
            transition: 'slide'
        }
    },

    onFirstAction: updatePreferences,
    onChange: updatePreferences,

    languages: {
        'en': {
            consent_modal: {
                title: 'We value your privacy',
                description: 'We use cookies to personalize content, remember your preferences, provide features, and analyze traffic to improve Capiller Rely Help. You can accept all cookies, reject non-essential cookies, or manage your preferences.',
                primary_btn: {
                    text: 'Accept all',
                    role: 'accept_all'
                },
                secondary_btn: {
                    text: 'Reject non-essential',
                    role: 'accept_necessary'
                },
                tertiary_btn: {
                    text: 'Preferences',
                    role: 'settings'
                }
            },
            settings_modal: {
                title: 'Cookie Preferences',
                save_settings_btn: 'Save selection',
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
                        description: 'Cookies are small text files used to make your experience on Capiller Rely Help smooth, secure, and reliable. Under data protection regulations, strictly necessary cookies do not require prior consent. For statistics, marketing, and preferences, we request your permission.'
                    },
                    {
                        title: 'Strictly necessary cookies',
                        description: 'These cookies are essential for the website to function properly, maintaining secure sessions, page navigation, and authentication. The website cannot function correctly without these cookies.',
                        toggle: {
                            value: 'necessary',
                            enabled: true,
                            readonly: true
                        },
                        cookie_table: [
                            {
                                col1: 'cookie_consent',
                                col2: 'capiller.com',
                                col3: "Stores the user's cookie consent preferences."
                            },
                            {
                                col1: '_deskbolic_session',
                                col2: 'capiller.com',
                                col3: 'Stores session and security tokens for the visitor.',
                                path: '/'
                            }
                        ]
                    },
                    {
                        title: 'Preference cookies',
                        description: 'Preference cookies enable the website to remember choices you make, such as your selected display currency or language settings.',
                        toggle: {
                            value: 'preference',
                            enabled: true,
                            readonly: false
                        },
                        cookie_table: [
                            {
                                col1: 'currency',
                                col2: 'capiller.com',
                                col3: 'Stores user-selected preferred pricing currency (USD, EUR, GBP, KRW).'
                            }
                        ]
                    },
                    {
                        title: 'Statistics cookies',
                        description: 'Statistics cookies help us understand how visitors interact with Capiller Rely Help by collecting anonymous metrics on page visits and error diagnostics.',
                        toggle: {
                            value: 'analytics',
                            enabled: true,
                            readonly: false
                        },
                        cookie_table: [
                            {
                                col1: '_ga',
                                col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>',
                                col3: 'Registers a unique ID that is used to generate statistical data about how the visitor uses the website.',
                                is_regex: true
                            },
                            {
                                col1: '_ga_*',
                                col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>',
                                col3: 'Collects session state data for Google Analytics 4.'
                            },
                            {
                                col1: '_gid',
                                col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>',
                                col3: 'Registers a unique ID to calculate visitor, session, and campaign data.'
                            },
                            {
                                col1: '_gat',
                                col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>',
                                col3: 'Used by Google Analytics to throttle request rate.'
                            }
                        ]
                    },
                    {
                        title: 'Marketing cookies',
                        description: 'Marketing cookies track visits and referrals across websites to measure ad effectiveness and attribute partner referral commissions.',
                        toggle: {
                            value: 'marketing',
                            enabled: true,
                            readonly: false
                        },
                        cookie_table: [
                            {
                                col1: 'ref',
                                col2: 'capiller.com',
                                col3: 'Stores affiliate and partner referral codes for proper attribution.'
                            },
                            {
                                col1: '_gcl_au',
                                col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>',
                                col3: 'Used by Google Ads / AdSense to experiment with advertisement efficiency.'
                            }
                        ]
                    },
                    {
                        title: 'Privacy Policy',
                        description: 'To learn more about how we process and safeguard your personal data, please read our <a href="/privacy" target="_blank" rel="noopener">Privacy Policy</a> or contact us at <a href="mailto:info@capiller.com">info@capiller.com</a>.'
                    }
                ]
            }
        },

        'es': {
            consent_modal: {
                title: 'Valoramos su privacidad',
                description: 'Utilizamos cookies para personalizar contenidos, recordar preferencias y analizar el tráfico de Capiller Rely Help. Puede aceptar todas las cookies, rechazar las no esenciales o personalizar sus preferencias.',
                primary_btn: {
                    text: 'Aceptar todo',
                    role: 'accept_all'
                },
                secondary_btn: {
                    text: 'Rechazar no esenciales',
                    role: 'accept_necessary'
                },
                tertiary_btn: {
                    text: 'Preferencias',
                    role: 'settings'
                }
            },
            settings_modal: {
                title: 'Preferencias de cookies',
                save_settings_btn: 'Guardar selección',
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
                        description: 'Las cookies son pequeños archivos de texto necesarios para que su experiencia en Capiller Rely Help sea eficiente y segura. Puede modificar sus preferencias en cualquier momento.'
                    },
                    {
                        title: 'Cookies estrictamente necesarias',
                        description: 'Permiten funciones básicas como la navegación y el acceso a zonas seguras. El sitio no puede funcionar correctamente sin ellas.',
                        toggle: { value: 'necessary', enabled: true, readonly: true },
                        cookie_table: [
                            { col1: 'cookie_consent', col2: 'capiller.com', col3: 'Guarda las opciones de consentimiento de cookies.' },
                            { col1: '_deskbolic_session', col2: 'capiller.com', col3: 'Mantiene la sesión y tokens de seguridad.', path: '/' }
                        ]
                    },
                    {
                        title: 'Cookies de preferencias',
                        description: 'Permiten recordar sus elecciones, como la moneda de precios o el idioma seleccionado.',
                        toggle: { value: 'preference', enabled: true, readonly: false },
                        cookie_table: [
                            { col1: 'currency', col2: 'capiller.com', col3: 'Almacena la moneda de pago seleccionada por el usuario.' }
                        ]
                    },
                    {
                        title: 'Cookies estadísticas',
                        description: 'Ayudan a entender cómo interactúan los visitantes con el sitio web de forma totalmente anónima.',
                        toggle: { value: 'analytics', enabled: true, readonly: false },
                        cookie_table: [
                            { col1: '_ga', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'Registra un ID único para generar métricas estadísticas.' },
                            { col1: '_ga_*', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'Mantiene el estado de la sesión en Google Analytics 4.' },
                            { col1: '_gid', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'Agrupa el comportamiento del usuario durante el día.' },
                            { col1: '_gat', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'Limita la tasa de peticiones a Google Analytics.' }
                        ]
                    },
                    {
                        title: 'Cookies de marketing',
                        description: 'Permiten atribuir conversiones y enlaces de afiliados.',
                        toggle: { value: 'marketing', enabled: true, readonly: false },
                        cookie_table: [
                            { col1: 'ref', col2: 'capiller.com', col3: 'Registra el código de referencia de afiliado para atribución.' },
                            { col1: '_gcl_au', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'Mide la efectividad publicitaria en Google Ads.' }
                        ]
                    },
                    {
                        title: 'Política de privacidad',
                        description: 'Para más información, consulte nuestra <a href="/privacy" target="_blank" rel="noopener">Política de Privacidad</a> o contáctenos en <a href="mailto:info@capiller.com">info@capiller.com</a>.'
                    }
                ]
            }
        },

        'de': {
            consent_modal: {
                title: 'Wir schätzen Ihre Privatsphäre',
                description: 'Wir verwenden Cookies, um Inhalte zu personalisieren, Einstellungen zu speichern und den Datenverkehr auf Capiller Rely Help zu analysieren. Sie können alle Cookies akzeptieren, nicht essenzielle ablehnen oder Ihre Einstellungen anpassen.',
                primary_btn: {
                    text: 'Alle akzeptieren',
                    role: 'accept_all'
                },
                secondary_btn: {
                    text: 'Nicht essenzielle ablehnen',
                    role: 'accept_necessary'
                },
                tertiary_btn: {
                    text: 'Einstellungen',
                    role: 'settings'
                }
            },
            settings_modal: {
                title: 'Cookie-Einstellungen',
                save_settings_btn: 'Auswahl speichern',
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
                        description: 'Cookies sind kleine Textdateien, die für den sicheren und zuverlässigen Betrieb von Capiller Rely Help erforderlich sind.'
                    },
                    {
                        title: 'Technisch notwendige Cookies',
                        description: 'Diese Cookies sind für den grundlegenden Betrieb der Website und sichere Sitzungen unerlässlich.',
                        toggle: { value: 'necessary', enabled: true, readonly: true },
                        cookie_table: [
                            { col1: 'cookie_consent', col2: 'capiller.com', col3: 'Speichert die Cookie-Einwilligung des Nutzers.' },
                            { col1: '_deskbolic_session', col2: 'capiller.com', col3: 'Speichert Sitzungs- und Sicherheitstoken.', path: '/' }
                        ]
                    },
                    {
                        title: 'Präferenz-Cookies',
                        description: 'Ermöglichen das Speichern von Nutzereinstellungen wie der gewählten Währung.',
                        toggle: { value: 'preference', enabled: true, readonly: false },
                        cookie_table: [
                            { col1: 'currency', col2: 'capiller.com', col3: 'Speichert die bevorzugte Anzeigewährung.' }
                        ]
                    },
                    {
                        title: 'Statistik-Cookies',
                        description: 'Helfen uns zu verstehen, wie Besucher mit der Website interagieren, um Capiller Rely Help zu optimieren.',
                        toggle: { value: 'analytics', enabled: true, readonly: false },
                        cookie_table: [
                            { col1: '_ga', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'Generiert anonyme statistische Daten zur Nutzung.' },
                            { col1: '_ga_*', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'Google Analytics 4 Sitzungsstatus.' },
                            { col1: '_gid', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'Gruppiert Nutzeraktionen innerhalb eines Tages.' },
                            { col1: '_gat', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'Drosselt Anfragen an Google Analytics.' }
                        ]
                    },
                    {
                        title: 'Marketing-Cookies',
                        description: 'Werden genutzt, um Werbewirksamkeit und Partner-Empfehlungen zuzuordnen.',
                        toggle: { value: 'marketing', enabled: true, readonly: false },
                        cookie_table: [
                            { col1: 'ref', col2: 'capiller.com', col3: 'Speichert Partner-Empfehlungscodes für die Zuordnung.' },
                            { col1: '_gcl_au', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'Wird von Google Ads zur Conversion-Messung verwendet.' }
                        ]
                    },
                    {
                        title: 'Datenschutzerklärung',
                        description: 'Weitere Informationen finden Sie in unserer <a href="/privacy" target="_blank" rel="noopener">Datenschutzerklärung</a> oder per E-Mail an <a href="mailto:info@capiller.com">info@capiller.com</a>.'
                    }
                ]
            }
        },

        'fr': {
            consent_modal: {
                title: 'Nous respectons votre vie privée',
                description: 'Nous utilisons des cookies pour personnaliser le contenu, mémoriser vos préférences et analyser le trafic sur Capiller Rely Help. Vous pouvez accepter tous les cookies, refuser les cookies non essentiels ou personnaliser vos choix.',
                primary_btn: {
                    text: 'Tout accepter',
                    role: 'accept_all'
                },
                secondary_btn: {
                    text: 'Refuser les non essentiels',
                    role: 'accept_necessary'
                },
                tertiary_btn: {
                    text: 'Personnaliser',
                    role: 'settings'
                }
            },
            settings_modal: {
                title: 'Préférences des cookies',
                save_settings_btn: 'Enregistrer la sélection',
                accept_all_btn: 'Tout accepter',
                reject_all_btn: 'Tout refuser',
                close_btn_label: 'Fermer',
                cookie_table_headers: [
                    { col1: 'Nom' },
                    { col2: 'Fournisseur' },
                    { col3: 'Finalité' }
                ],
                blocks: [
                    {
                        title: 'Utilisation des cookies',
                        description: 'Les cookies sont de petits fichiers texte nécessaires au fonctionnement sécurisé et personnalisé de Capiller Rely Help.'
                    },
                    {
                        title: 'Cookies strictement nécessaires',
                        description: 'Ces cookies sont indispensables au fonctionnement normal du site et à la sécurité de la session.',
                        toggle: { value: 'necessary', enabled: true, readonly: true },
                        cookie_table: [
                            { col1: 'cookie_consent', col2: 'capiller.com', col3: 'Conserve vos préférences de consentement de cookies.' },
                            { col1: '_deskbolic_session', col2: 'capiller.com', col3: 'Maintient la session sécurisée du visiteur.', path: '/' }
                        ]
                    },
                    {
                        title: 'Cookies de préférences',
                        description: 'Permettent de mémoriser des informations qui modifient le comportement du site, comme la devise d\'affichage.',
                        toggle: { value: 'preference', enabled: true, readonly: false },
                        cookie_table: [
                            { col1: 'currency', col2: 'capiller.com', col3: 'Stocke la devise choisie pour les tarifs.' }
                        ]
                    },
                    {
                        title: 'Cookies statistiques',
                        description: 'Nous aident à comprendre comment les visiteurs naviguent sur le site de manière anonyme.',
                        toggle: { value: 'analytics', enabled: true, readonly: false },
                        cookie_table: [
                            { col1: '_ga', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'Identifiant unique pour les statistiques Google Analytics.' },
                            { col1: '_ga_*', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'Maintient l\'état de session dans GA4.' },
                            { col1: '_gid', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'Identifiant pour regrouper les pages vues sur 24h.' },
                            { col1: '_gat', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'Régule le débit des requêtes vers Google Analytics.' }
                        ]
                    },
                    {
                        title: 'Cookies marketing',
                        description: 'Mesurent l\'efficacité publicitaire et attribuent les recommandations d\'affiliés.',
                        toggle: { value: 'marketing', enabled: true, readonly: false },
                        cookie_table: [
                            { col1: 'ref', col2: 'capiller.com', col3: 'Conserve le code d\'affiliation pour l\'attribution des commissions.' },
                            { col1: '_gcl_au', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'Utilisé par Google Ads pour mesurer les conversions.' }
                        ]
                    },
                    {
                        title: 'Politique de confidentialité',
                        description: 'Consultez notre <a href="/privacy" target="_blank" rel="noopener">Politique de confidentialité</a> ou écrivez-nous à <a href="mailto:info@capiller.com">info@capiller.com</a>.'
                    }
                ]
            }
        },

        'pt-BR': {
            consent_modal: {
                title: 'Valorizamos sua privacidade',
                description: 'Usamos cookies para personalizar conteúdos, lembrar suas preferências e analisar o tráfego no Capiller Rely Help. Você pode aceitar todos os cookies, rejeitar os não essenciais ou gerenciar suas preferências.',
                primary_btn: {
                    text: 'Aceitar todos',
                    role: 'accept_all'
                },
                secondary_btn: {
                    text: 'Rejeitar não essenciais',
                    role: 'accept_necessary'
                },
                tertiary_btn: {
                    text: 'Preferências',
                    role: 'settings'
                }
            },
            settings_modal: {
                title: 'Preferências de cookies',
                save_settings_btn: 'Salvar seleção',
                accept_all_btn: 'Aceitar todos',
                reject_all_btn: 'Rejeitar todos',
                close_btn_label: 'Fechar',
                cookie_table_headers: [
                    { col1: 'Nome' },
                    { col2: 'Provedor' },
                    { col3: 'Finalidade' }
                ],
                blocks: [
                    {
                        title: 'Uso de cookies',
                        description: 'Cookies são pequenos arquivos de texto essenciais para garantir que sua experiência no Capiller Rely Help seja segura e contínua.'
                    },
                    {
                        title: 'Cookies estritamente necessários',
                        description: 'Fundamentais para a navegação no site e sessões seguras. Não podem ser desativados.',
                        toggle: { value: 'necessary', enabled: true, readonly: true },
                        cookie_table: [
                            { col1: 'cookie_consent', col2: 'capiller.com', col3: 'Armazena suas preferências de consentimento de cookies.' },
                            { col1: '_deskbolic_session', col2: 'capiller.com', col3: 'Mantém a sessão segura e tokens do visitante.', path: '/' }
                        ]
                    },
                    {
                        title: 'Cookies de preferências',
                        description: 'Lembram escolhas como sua moeda de exibição e idioma preferido.',
                        toggle: { value: 'preference', enabled: true, readonly: false },
                        cookie_table: [
                            { col1: 'currency', col2: 'capiller.com', col3: 'Armazena a moeda selecionada para exibição de planos.' }
                        ]
                    },
                    {
                        title: 'Cookies de estatísticas',
                        description: 'Ajudam a entender anonimamente como os visitantes interagem com a plataforma.',
                        toggle: { value: 'analytics', enabled: true, readonly: false },
                        cookie_table: [
                            { col1: '_ga', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'Gera métricas estatísticas anônimas de navegação.' },
                            { col1: '_ga_*', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'Mantém o estado da sessão no GA4.' },
                            { col1: '_gid', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'Identificador para agrupar páginas visitadas em 24h.' },
                            { col1: '_gat', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'Controla a taxa de requisições ao Google Analytics.' }
                        ]
                    },
                    {
                        title: 'Cookies de marketing',
                        description: 'Permitem mensurar o retorno de anúncios e atribuir indicações de parceiros.',
                        toggle: { value: 'marketing', enabled: true, readonly: false },
                        cookie_table: [
                            { col1: 'ref', col2: 'capiller.com', col3: 'Registra o código de afiliado para atribuição de comissões.' },
                            { col1: '_gcl_au', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'Mede conversões e eficiência de anúncios no Google Ads.' }
                        ]
                    },
                    {
                        title: 'Política de Privacidade',
                        description: 'Saiba mais em nossa <a href="/privacy" target="_blank" rel="noopener">Política de Privacidade</a> ou pelo e-mail <a href="mailto:info@capiller.com">info@capiller.com</a>.'
                    }
                ]
            }
        },

        'ar': {
            consent_modal: {
                title: 'نحن نهتم بخصوصيتك',
                description: 'يستخدم ديسكبوليك ملفات تعريف الارتباط لتحسين تجربة التصفح، وتذكر تفضيلاتك، وتحليل حركة المرور. يمكنك قبول جميع الملفات، أو رفض غير الأساسية، أو تخصيص تفضيلاتك.',
                primary_btn: {
                    text: 'قبول الكل',
                    role: 'accept_all'
                },
                secondary_btn: {
                    text: 'رفض غير الأساسية',
                    role: 'accept_necessary'
                },
                tertiary_btn: {
                    text: 'تخصيص التفضيلات',
                    role: 'settings'
                }
            },
            settings_modal: {
                title: 'إعدادات ملفات تعريف الارتباط',
                save_settings_btn: 'حفظ الاختيارات',
                accept_all_btn: 'قبول الكل',
                reject_all_btn: 'رفض الكل',
                close_btn_label: 'إغلاق',
                cookie_table_headers: [
                    { col1: 'الاسم' },
                    { col2: 'المزود' },
                    { col3: 'الغرض' }
                ],
                blocks: [
                    {
                        title: 'استخدام ملفات تعريف الارتباط',
                        description: 'ملفات تعريف الارتباط هي ملفات نصية صغيرة تساعد في ضمان عمل ديسكبوليك بأمان وموثوقية.'
                    },
                    {
                        title: 'ملفات تعريف الارتباط الضرورية للغاية',
                        description: 'هذه الملفات أساسية لعمل الموقع وتمكين الأمان وتسجيل الدخول ولا يمكن إيقافها.',
                        toggle: { value: 'necessary', enabled: true, readonly: true },
                        cookie_table: [
                            { col1: 'cookie_consent', col2: 'capiller.com', col3: 'تخزين تفضيلات الموافقة على ملفات تعريف الارتباط.' },
                            { col1: '_deskbolic_session', col2: 'capiller.com', col3: 'الحفاظ على جلسة وأمان الزائر.', path: '/' }
                        ]
                    },
                    {
                        title: 'ملفات تعريف ارتباط التفضيلات',
                        description: 'تتيح للموقع تذكر اختياراتك مثل العملة المفضلة لعرض الأسعار.',
                        toggle: { value: 'preference', enabled: true, readonly: false },
                        cookie_table: [
                            { col1: 'currency', col2: 'capiller.com', col3: 'تخزين العملة المحددة لعرض الأسعار.' }
                        ]
                    },
                    {
                        title: 'ملفات تعريف الارتباط الإحصائية',
                        description: 'تساعدنا على فهم كيفية تفاعل الزوار مع الموقع بشكل مجهول الهوية لتحسين خدماتنا.',
                        toggle: { value: 'analytics', enabled: true, readonly: false },
                        cookie_table: [
                            { col1: '_ga', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'تسجيل معرّف فريد لتوليد بيانات إحصائية مجهولة.' },
                            { col1: '_ga_*', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'الاحتفاظ بحالة الجلسة لـ Google Analytics 4.' },
                            { col1: '_gid', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'تجميع سلوك التصفح على مدار 24 ساعة.' },
                            { col1: '_gat', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'الحد من معدل الطلبات في Google Analytics.' }
                        ]
                    },
                    {
                        title: 'ملفات تعريف الارتباط التسويقية',
                        description: 'تُستخدم لقياس فعالية الحملات وتتبع روابط الإحالة للشركاء.',
                        toggle: { value: 'marketing', enabled: true, readonly: false },
                        cookie_table: [
                            { col1: 'ref', col2: 'capiller.com', col3: 'تخزين رمز الإحالة التابع للشركاء.' },
                            { col1: '_gcl_au', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'تتبع كفاءة وتحويلات إعلانات Google Ads.' }
                        ]
                    },
                    {
                        title: 'سياسة الخصوصية',
                        description: 'لمزيد من المعلومات، يرجى قراءة <a href="/privacy" target="_blank" rel="noopener">سياسة الخصوصية</a> أو التواصل عبر <a href="mailto:info@capiller.com">info@capiller.com</a>.'
                    }
                ]
            }
        },

        'ko': {
            consent_modal: {
                title: '고객님의 개인정보를 소중히 생각합니다',
                description: 'Capiller Rely Help은 서비스 기능 제공, 환경설정 기억, 맞춤형 콘텐츠 제공 및 웹사이트 트래픽 분석을 위해 쿠키를 사용합니다. 모든 쿠키를 수락하거나, 필수 외 쿠키를 거부하거나, 직접 설정을 변경할 수 있습니다.',
                primary_btn: {
                    text: '모두 수락',
                    role: 'accept_all'
                },
                secondary_btn: {
                    text: '필수 외 거부',
                    role: 'accept_necessary'
                },
                tertiary_btn: {
                    text: '쿠키 설정',
                    role: 'settings'
                }
            },
            settings_modal: {
                title: '쿠키 환경설정',
                save_settings_btn: '선택 항목 저장',
                accept_all_btn: '모두 수락',
                reject_all_btn: '모두 거부',
                close_btn_label: '닫기',
                cookie_table_headers: [
                    { col1: '쿠키명' },
                    { col2: '제공자' },
                    { col3: '수집 목적' }
                ],
                blocks: [
                    {
                        title: '쿠키 사용 안내',
                        description: '쿠키는 웹사이트가 원활하고 안전하게 작동할 수 있도록 지원하는 작은 텍스트 파일입니다.'
                    },
                    {
                        title: '필수 쿠키',
                        description: '웹사이트의 기본 기능(보안 세션, 페이지 탐색)을 지원하며 비활성화할 수 없습니다.',
                        toggle: { value: 'necessary', enabled: true, readonly: true },
                        cookie_table: [
                            { col1: 'cookie_consent', col2: 'capiller.com', col3: '이용자의 쿠키 동의 설정을 저장합니다.' },
                            { col1: '_deskbolic_session', col2: 'capiller.com', col3: '안전한 방문자 세션 토큰을 유지합니다.', path: '/' }
                        ]
                    },
                    {
                        title: '기능 및 설정 쿠키',
                        description: '선택하신 요금제 통화 및 언어 설정을 기억합니다.',
                        toggle: { value: 'preference', enabled: true, readonly: false },
                        cookie_table: [
                            { col1: 'currency', col2: 'capiller.com', col3: '이용자가 선택한 요금제 표시 통화를 저장합니다.' }
                        ]
                    },
                    {
                        title: '통계 및 분석 쿠키',
                        description: '방문자의 사이트 이용 통계를 익명으로 분석하여 서비스 품질을 개선합니다.',
                        toggle: { value: 'analytics', enabled: true, readonly: false },
                        cookie_table: [
                            { col1: '_ga', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: '익명 통계 데이터 생성을 위한 고유 ID를 부여합니다.' },
                            { col1: '_ga_*', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'Google Analytics 4 세션 상태를 유지합니다.' },
                            { col1: '_gid', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: '24시간 동안의 사용자 페이지 이용 행태를 집계합니다.' },
                            { col1: '_gat', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'Google Analytics 요청 빈도를 조절합니다.' }
                        ]
                    },
                    {
                        title: '마케팅 쿠키',
                        description: '광고 캠페인의 성과를 측정하고 파트너 추천 링크를 추적합니다.',
                        toggle: { value: 'marketing', enabled: true, readonly: false },
                        cookie_table: [
                            { col1: 'ref', col2: 'capiller.com', col3: '제휴 파트너 추천 코드를 저장합니다.' },
                            { col1: '_gcl_au', col2: '<a href="https://google.com" target="_blank" rel="noopener">Google</a>', col3: 'Google Ads 전환 및 마케팅 효율을 측정합니다.' }
                        ]
                    },
                    {
                        title: '개인정보 처리방침',
                        description: '자세한 사항은 <a href="/privacy" target="_blank" rel="noopener">개인정보 처리방침</a>을 확인하시거나 <a href="mailto:info@capiller.com">info@capiller.com</a>으로 문의해 주시기 바랍니다.'
                    }
                ]
            }
        }
    }
});

// Alias 'pt' to 'pt-BR'
if (cc && cc.languages) {
    cc.languages['pt'] = cc.languages['pt-BR'];
}

// Delegated click listener for Turbo navigation
document.addEventListener('click', function(event) {
    var trigger = event.target.closest('[data-cc]');
    if (!trigger) return;

    var role = trigger.getAttribute('data-cc');
    if (role === 'c-settings') {
        event.preventDefault();
        if (window.cc) window.cc.showSettings(0);
    } else if (role === 'accept-all') {
        event.preventDefault();
        if (window.cc) {
            window.cc.accept('all');
            window.cc.hideSettings();
            window.cc.hide();
        }
    } else if (role === 'accept-necessary') {
        event.preventDefault();
        if (window.cc) {
            window.cc.accept([]);
            window.cc.hideSettings();
            window.cc.hide();
        }
    }
});

// Update language when navigating via Turbo
document.addEventListener("turbo:load", function() {
    if (window.cc && typeof window.cc.updateLanguage === 'function') {
        var docLang = document.documentElement.lang || 'en';
        window.cc.updateLanguage(docLang);
    }
});
