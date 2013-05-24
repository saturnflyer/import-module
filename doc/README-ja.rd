=begin
= import-module

2005.02.02

*Version: 0.82
*����: ���@�M��Y
*���[��: sinara@blade.nagaokaut.ac.jp
*�z�[���y�[�W: ((<URL:http://blade.nagaokaut.ac.jp/~sinara/ruby/import-module/>))

== �Љ�

import-module �̓��W���[���̃C���N���[�h�𓮓I�ɍs���܂��B

== �C���X�g�[��

���j�b�N�X�n�� OS �Ȃ��

  ruby install.rb

�Ƃ��Ă��������B�܂��A lib/*.rb ���Aruby �� require �ł���ꏊ��
�R�s�[���Ă��\���܂���B

== �p�@

(({reqruire "import-method"}))�������((|Module|))�Ɉȉ��̃��\�b�h��
�t���������܂��B

--- import_module(mod) { ... }
    ((|mod|)) �����W���[���Ƃ��Ď�荞�񂾏�Ԃ� ... �����s���܂��B

    (��)
      require "import-module"
      class Foo
        def hello
          puts 'hello'
        end
      end
  
      module Bar
        def hello
          puts 'bye'
        end
      end
  
      module Baz
        def hello
          puts 'good-bye'
        end
      end
  
      foo = Foo.new
      foo.hello                   #=> hello
      Foo.import_module(Bar) do
        foo.hello                 #=> bye
        Foo.import_module(Baz) do
          foo.hello               #=> good-bye
        end
        foo.hello                 #=> bye
      end
      foo.hello                   #=> hello

--- adopt_module(mod)
    ((|mod|)) �����W���[���Ƃ��Ď�荞�݂܂��B

    (��)
      require "import-module"
      class Foo
        def hello
          puts 'hello'
        end
      end
  
      module Bar
        def hello
          puts 'bye'
        end
      end
      
      foo = Foo.new
      Foo.adopt_module(Bar)
      foo.hello                 #=> bye

�܂��A((|Object|))�ɂ͎��̃��\�b�h���t�������܂��B

--- import(mod) { ... }
    �I�u�W�F�N�g�� ((|mod|)) �����W���[���Ƃ��Ď�荞�񂾏�Ԃ� ... �����s���܂��B

    (��)
      require "import-module"
      class Foo
        def hello
          puts 'hello'
        end
      end
      
      module Bar
        def hello
          puts 'bye'
        end
      end
      
      foo = Foo.new
      bar = Foo.new
      foo.hello                   #=> hello
      bar.hello                   #=> hello
      foo.import(Bar) do |foo0|
        foo.hello                 #=> bye
        p foo == foo0             #=> true
        bar.hello                 #=> hello
      end
      foo.hello                   #=> hello
      bar.hello                   #=> hello


--- adopt(mod)
    �I�u�W�F�N�g�� ((|mod|)) �����W���[���Ƃ��Ď�荞�݂܂��B

    (��)
      require "import-module"
      class Foo
        def hello
          puts 'hello'
        end
      end
  
      module Bar
        def hello
          puts 'bye'
        end
      end
  
      foo = Foo.new
      bar = Foo.new
      foo.adopt(Bar)
      foo.hello                   #=> bye
      bar.hello                   #=> hello

== �}���`�X���b�h

���̃��C�u�����̓}���`�X���b�h�Ή����Ă��܂��B

(��)
      require "import-module"
      class Foo
        def hello
          puts 'hello'
        end
      end
      
      module Bar
        def hello
          puts 'bye'
        end
      end
      
      foo = Foo.new
      foo.hello #=> hello
      Thread.start do
        Foo.import_module(Bar) do
          foo.hello #=> bye
        end
      end
      foo.hello #=> hello

�}���`�X���b�h�Ή����K�v�łȂ��ꍇ�́A
(({$import_module_single_thread = true})) �Ƃ��Ă���
(({import-module.rb})) �� require ���邩�A
(({import-module.rb})) �ł͂Ȃ��A
(({import-module-single-thread.rb})) �� require ���Ă��������B
���\�b�h�̌Ăяo���������Ȃ�܂��B

== �g�����̗�
=== Modify Enumerable
Enumerable �̈ꎞ�I�ȕύX

      require "import-module"
      module EachChar
       def each(&b); split(//).each(&b); end
      end
      p "abc".import(EachChar){|s| s.map{|x| x.succ}}.join("") #=> "bcd"

#=== Use Original Method
#((|set_orig_method|)) �ŃI���W�i���ȃ��\�b�h�ɖ��O��t����B
#
#      require "import-module"
#      module IndexedEach
#        set_orig_method :_each, :each
#        def each
#          i = 0
#          _each do |x|
#            yield(i, x)
#            i += 1
#          end
#        end
#      end
#      
#      Array.import_module(IndexedEach) do
#        [10, 11, 12].each do |i, x|
#           p [i, x] #=> [0, 10]
#                    #   [1, 11]
#                    #   [2, 12]
#        end
#      end

=== Determinant
�����l�s������̂܂ܗL�����l�s��Ƃ��Ĉ����B

      require "import-module"
      require "matrix"
      require "rational"
      
      module RationalDiv
        def /(other)
          Rational(self) / other
        end
      end
      
      a = Matrix[[2, 1], [3, 1]]
      puts a.det   #=> 0
      Fixnum.import_module(RationalDiv) do
        puts a.det #=> -1
      end
      puts a.det   #=> 0


== �Q�l

RAA ((<URL:http://www.ruby-lang.org/en/raa.html>)) �ɂ�����ȉ��̃v���O�������Q
�l�ɂ��܂����B
* Ruby Behaviors (David Alan Black)
* scope-in-state (Keiju Ishitsuka)
* class-in-state (Keiju Ishitsuka)

== ����
0.82 (2005.02.02)
* id => object_id

0.81 (2004.03.10)
* �ăp�b�P�[�W

0.80 (2003.06.29)
* adapted to 1.8.0(preview3)
* adapted to 1.6.8

0.79 (2003.05.02)
* $import_module_single_thread ����
* install.rb �Y�t

0.78 (2003.05.01)
* ���\�b�h�̉����̕ۑ��ɂ��� bug fix

0.77 (2002.11.05)
* proxy object �� Hash ���� Array �ɕύX��������

0.76 (2002.11.01)
* ����(protected)�̕ۑ�

0.75 (2002.10.31)
* set_orig_method ����

0.74 (2002.10.30)
* Stack#update ���� Scope#update �ֈړ�
* Stack#export_current ����
* test, test-import-module.rb test-time.rb ��������

0.73 (2002.10.28)
* Stack �ύX
* ImportModule#import_module_init �p�~
* Thread#__IMPORT_MODULE_PREFIX_proxy, stack ����
* test scripts ����

0.72 (2002.10.22)
* Import_Module::Scope.create ����
* Scope_Module �p�~

0.71 (2002.10.20)
* Scope_Module �N���X����
* optimize: &b -> b -> b -> &b
* import-module-single-thread.rb ����
* Import_Module.single_thread �p�~

0.70 (2002.10.17)
* Scope �N���X����
* import-module-pip.rb
* import-moudle-unbound-method.rb

0.60 (2002.10.15)
* �N���X Target, Source, Stack �ɕ���

0.60beta6 (2002.10.15)
* �㗝�p���p�^�[�����p�̍Ō�

0.52 (2002.10.10)
* �^�[�Q�b�g�̃��\�b�h���Ē�`���������
* thread safe mode ���f�t�H���g��
* thread_safe ���\�b�h��p�~
* single_thread_mode ���\�b�h��ǉ�

0.51 (2002.10.09)
* ���\�b�h�̃p�����[�^�̓W�J�E�W��̗}�� (Import_Module)

0.50 (2002.10.03)
* scope-in-state �̑㗝�p���p�^�[���̎����� (Import_Module)
* stack �� alias �x�[�X���烂�W���[���̔z��x�[�X�ɕύX (Import_Module_Single_Thread)
* $IMPORT_MODULE_thread_safe �̔p�~
* Import_Module.thread_safe �̓���
* Super �@�\���~
=end
