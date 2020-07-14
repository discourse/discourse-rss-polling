// addFeaturedLinkMetaDecorator
import { withPluginApi } from "discourse/lib/plugin-api";
import { addFeaturedLinkMetaDecorator } from 'discourse/lib/render-topic-featured-link';
export default {
  name: 'mod-featured-link', 
  initialize(){
    withPluginApi('0.8.33', modFeatured);
  }
}

const modFeatured = (api) => {
  addFeaturedLinkMetaDecorator(function(meta){
    meta.domain = /^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)/.exec(meta.href)[1];
  })
}