package CheckFolder::Plugin;
use strict;
use warnings;
use utf8;
use Data::Dumper;

our $plugin = MT->component('CheckFolder');

sub insert_before {
    my ( $tmpl, $id, $template_name ) = @_;

    my $after = $tmpl->getElementById($id);
    foreach my $t ( @{ $plugin->load_tmpl($template_name)->tokens } ) {
        $tmpl->insertBefore( $t, $after );
    }
}

sub hdlr_template_source_edit_template {
    my ($cb, $app, $param, $tmpl) = @_;

    my $config =
    $plugin->get_config_value(
        'setting_system', 'system'
    );
    my $get_type = $app->param('_type') || 0;
    if ($config && $get_type eq 'page') {
        insert_before( $tmpl, 'footer_include', 'check_folder.tmpl' );
    }
}

sub doLog {
    my ($msg) = @_;
    return unless defined($msg);

    use MT::Log;
    my $log = MT::Log->new;
    $log->message($msg) ;
    $log->save or die $log->errstr;
}

1;