conf = configuration_data()
conf.set('prefix', get_option('prefix'))
conf.set('libdir', get_option ('libdir'))
conf.set('PROJECT_NAME', 'Caramelo')
conf.set('PROJECT_VERSION', '0.0.1')
conf.set('API_VERSION', API_VERSION)

sources = files([
  'library.vala',
  'Iterator.vala',
  'BidirectionalIterator.vala',
  'Closures.vala',
  'Iterable.vala',
  'Collection.vala',
  'List.vala',
  'SingleLinkedList.vala',
  'LinkedList.vala',
  'Map.vala',
  'MapIterator.vala',
  'HashMap.vala',
  'HashSet.vala',
  'Set.vala',
  'Queue.vala',
  'LinkedQueue.vala',
])

libcaramelo = library('libcaramelo-' + API_VERSION,
  sources,
  vala_header: 'libcaramelo.h',
  vala_vapi: 'libcaramelo-' + API_VERSION + '.vapi',
  vala_gir: 'Caramelo-' + API_VERSION + '.gir',
  dependencies : dependencies,
  vala_args: [
    '--abi-stability'
    ],
  install: true,
  install_dir: [
    true,
    get_option('includedir') / 'libcaramelo-' + API_VERSION / 'libcaramelo',
    vapidir,
    g_ir_compiler.found()
  ]
)

caramelo_dep = declare_dependency (
  link_with: libcaramelo,
  dependencies: dependencies,
  include_directories: [include_directories('.')],
)

if g_ir_compiler.found()
  custom_target('libcaramelo-typelib',
    command: [
      g_ir_compiler,
      '--shared-library', 'libcaramelo-@0@.so'.format (API_VERSION),
      '--output', '@OUTPUT@',
      meson.current_build_dir() / 'Caramelo-' + API_VERSION + '.gir'
    ],
    output: 'Caramelo-' + API_VERSION + '.typelib',
    depends: libcaramelo,
    install: true,
    install_dir: join_paths(get_option('libdir'), 'girepository-1.0'))
endif

pkgconfig.generate(libcaramelo,
  subdirs: 'libcaramelo-' + API_VERSION,
  version: API_VERSION,
  name: 'libcaramelo',
  filebase: 'libcaramelo-' + API_VERSION,
  requires: PKGCONFIG_DEPS,
  description: 'A data structure library for Vala')

if get_option('enable_valadoc')
  valadoc = find_program('valadoc')
  libcaramelo_docs = custom_target('libcaramelo_apidocs',
    input: sources,
    install: true,
    # FIXME: Installing to tmp, so the target will be built
    #        the problem is we cannot access a subfolder of the
    #        buildtarget via the output parameter.
    #        Find a nicer solution
    install_dir: get_option('datadir') / 'devhelp' / 'books',
    command: [
      valadoc,
      '-o', meson.current_build_dir() / 'Caramelo-' + API_VERSION,
      '--doclet',
      'devhelp',
      '@INPUT@',
      '--force'
    ],
    output: 'Caramelo-' + API_VERSION)

  install_subdir(meson.current_build_dir() / 'Caramelo-' + API_VERSION / 'Caramelo-' + API_VERSION,
    install_dir: get_option('datadir') / 'devhelp' / 'books')
endif
