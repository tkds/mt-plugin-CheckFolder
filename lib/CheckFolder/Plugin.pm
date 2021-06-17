package CheckFolder::Plugin;
use strict;
use warnings;
use MT;
use utf8;
use Data::Dumper;

sub plugin {
    MT->component('CheckFolder');
}

sub insert_before {
    my ( $tmpl, $id, $template_name ) = @_;

    my $node_id = $tmpl->getElementById($id);
    my $js_node = $tmpl->createElement('setvarblock', { name => 'jq_js_include', append => 1 });
    $js_node->innerHTML(plugin()->load_tmpl($template_name)->output);

    $tmpl->insertBefore($js_node, $node_id);
}

sub hdlr_template_source_edit_template {
    my ($cb, $app, $param, $tmpl) = @_;

    my $config = plugin()->get_config_value(
        'setting_system', 'system'
    );
    
    my $get_type = $app->param('_type') || 0;
    if ($config && $get_type eq 'page') {
        insert_before($tmpl, 'include_default_layout', 'check_folder.tmpl');
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