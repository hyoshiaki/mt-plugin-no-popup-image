package MT::Plugin::NoPopupImage;

use strict;
use base qw( MT::Plugin );
use MT;

our $VERSION = '0.01';

my $plugin = __PACKAGE__->new({
    id => 'NoPopupImage',
    name => 'NoPopupImage',
    version => $VERSION,
    description => '<MT_TRANS phrase="NoPopupImage.">',
    author_name => 'hyoshiaki',
    author_link => 'https://hyoshiaki.github.io/',
    l10n_class  => 'NoPopupImage::L10N'
});
MT->add_plugin( $plugin );

*MT::Asset::Image::insert_options = \&insert_options;

sub insert_options {
    my $asset = shift;
    my ($param) = @_;
      my $app   = MT->instance;
       $app->{plugin_template_path} = File::Spec->catdir($plugin->path,'tmpl');
    my $perms = $app->{perms};
    my $blog  = $asset->blog or return;

    $param->{do_thumb}
        = $asset->has_thumbnail && $asset->can_create_thumbnail ? 1 : 0;
    $param->{wrap_text}  = $blog->image_default_wrap_text ? 1 : 0;
    $param->{make_thumb} = $blog->image_default_thumb     ? 1 : 0;
    $param->{ 'align_' . $_ }
        = ( $blog->image_default_align || 'none' ) eq $_ ? 1 : 0
        for qw(none left center right);
    $param->{ 'unit_w' . $_ }
        = ( $blog->image_default_wunits || 'pixels' ) eq $_ ? 1 : 0
        for qw(percent pixels);
    $param->{thumb_width}
        = $blog->image_default_width
        || $asset->image_width
        || 0;

    return $app->build_page( 'insert_options_image.tmpl', $param );
}

1;
