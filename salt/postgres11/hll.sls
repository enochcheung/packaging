{% set VERSION = '2.12' %}

download_hll:
  archive.extracted:
    - name: /home/vagrant/hll
    - source: https://github.com/citusdata/postgresql-hll/archive/v{{ VERSION }}.tar.gz
    - source_hash: md5=bcc2dfef98ceb8d7dcb6657fdd0fb5a9
    - user: vagrant
    - archive_format: tar

make_hll:
  cmd.run:
    - name: make
    - cwd: /home/vagrant/hll/postgresql-hll-{{ VERSION }}
    - creates: /home/vagrant/hll/postgresql-hll-{{ VERSION }}/hll.o
    - require:
      - pkg: install_postgres_headers
      - archive: download_hll

construct_hll_install_dir:
  file.directory:
    - name: /tmp/hll
    - user: vagrant

install_hll:
  cmd.run:
    - name: make install DESTDIR=/tmp/hll
    - cwd: /home/vagrant/hll/postgresql-hll-{{ VERSION }}
    - creates: /tmp/hll/usr

package_hll:
  cmd.run:
    - name: fpm -s dir -t deb -n "postgres11-hll" -v "{{ VERSION }}" -C /tmp/hll usr
    - creates: /vagrant/postgres11-hll_{{ VERSION }}_amd64.deb
    - cwd: /vagrant
    - user: vagrant
    - require:
      - gem: fpm
