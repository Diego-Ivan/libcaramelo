test_env = [
  'G_TEST_SRCDIR=@0@'.format(meson.current_source_dir()),
  'G_TEST_BUILDDIR=@0@'.format(meson.current_build_dir()),
]

base_tests = files([
  'TestCase.vala',
  'CollectionTest.vala',
])

list_test = executable('list-test',
  base_tests,
  'ListTest.vala',
  dependencies: [caramelo_dep]
)

test ('lists', list_test, env: test_env)